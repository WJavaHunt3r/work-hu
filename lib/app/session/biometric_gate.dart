import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/session/biometric_lock.dart';

/// Covers the whole app while [biometricLockProvider] is locked (sits in `MaterialApp.builder`, above every route and
/// sheet). Asks for Face ID / fingerprint as soon as it shows; "Belépés jelszóval" signs out to the login page.
class BiometricGate extends ConsumerStatefulWidget {
  const BiometricGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends ConsumerState<BiometricGate> with WidgetsBindingObserver {
  bool _prompting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _promptIfLocked());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final notifier = ref.read(biometricLockProvider.notifier);
    // Not "inactive": the Face ID sheet itself makes the app inactive for a moment
    if (lifecycle == AppLifecycleState.paused || lifecycle == AppLifecycleState.hidden) {
      notifier.wentToBackground();
    } else if (lifecycle == AppLifecycleState.resumed) {
      notifier.cameBack(signedIn: ref.read(userDataProvider).user != null);
      _promptIfLocked();
    }
  }

  Future<void> _promptIfLocked() async {
    if (_prompting || !mounted || !ref.read(biometricLockProvider).locked) return;
    _prompting = true;
    try {
      await ref.read(biometricLockProvider.notifier).unlock("biometric_unlock_reason".i18n());
    } finally {
      _prompting = false;
    }
  }

  Future<void> _signInWithPassword() async {
    // logout() switches the lock off too (see UserProvider.logout)
    await ref.read(userDataProvider).logout();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDataProvider.select((p) => p.user == null), (_, signedOut) {
      if (signedOut) ref.read(biometricLockProvider.notifier).signedOut();
    });
    final locked = ref.watch(biometricLockProvider.select((s) => s.locked)) && ref.watch(userDataProvider).user != null;
    return Stack(
      children: [
        // Not just covered: nothing under the lock can be focused or read out by a screen reader
        ExcludeSemantics(excluding: locked, child: AbsorbPointer(absorbing: locked, child: widget.child)),
        if (locked) Positioned.fill(child: _LockScreen(onUnlock: _promptIfLocked, onPassword: _signInWithPassword)),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock, required this.onPassword});

  final VoidCallback onUnlock;
  final VoidCallback onPassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            children: [
              const Spacer(),
              ClipOval(child: Image.asset('assets/icons/dukapp_icon_round.png', width: 88.sp, height: 88.sp)),
              SizedBox(height: 24.sp),
              Text(
                "biometric_locked_title".i18n(),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.sp),
              Text(
                "biometric_locked_hint".i18n(),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onUnlock,
                  icon: const Icon(Icons.fingerprint),
                  label: Text("biometric_unlock".i18n()),
                ),
              ),
              SizedBox(height: 8.sp),
              TextButton(onPressed: onPassword, child: Text("biometric_use_password".i18n())),
            ],
          ),
        ),
      ),
    );
  }
}
