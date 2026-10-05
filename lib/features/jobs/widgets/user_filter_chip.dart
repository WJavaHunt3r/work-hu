import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/provider/user_combo_provider.dart';

/// A filter chip for one user: shows "label: name" once a user is picked (with a delete button), and opens a user
/// search when tapped.
class UserFilterChip extends StatelessWidget {
  const UserFilterChip({
    super.key,
    required this.label,
    required this.userName,
    required this.onSelected,
    required this.onDeleted,
  });

  /// i18n key of the filter, e.g. "jobs_filter_responsible".
  final String label;
  final String? userName;
  final void Function(UserComboModel user) onSelected;
  final VoidCallback onDeleted;

  Future<void> _pick(BuildContext context) async {
    final user = await showDialog<UserComboModel>(
      context: context,
      builder: (_) => UserSearchDialog(title: label),
    );
    if (user != null) onSelected(user);
  }

  /// Looks like the other filter chips (see BaseFilterChip): primary container when active, "label: value" text.
  @override
  Widget build(BuildContext context) {
    final selected = userName != null;
    return Padding(
      padding: EdgeInsets.only(right: 8.sp),
      child: FilterChip(
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        showCheckmark: false,
        selected: selected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("header_label".i18n([label.i18n(), userName ?? ""])),
            Visibility(visible: !selected, child: const Icon(Icons.arrow_drop_down)),
          ],
        ),
        onDeleted: selected ? onDeleted : null,
        onSelected: (_) => _pick(context),
      ),
    );
  }
}

/// Full-screen user search: type a name, pick from the results. Returns the chosen user, or null when closed.
///
/// Not an overlay under a text field (as in UserComboWidget): inside a small dialog the overlay was placed far from
/// the field, so the results are an ordinary list here.
class UserSearchDialog extends ConsumerStatefulWidget {
  const UserSearchDialog({super.key, required this.title});

  /// i18n key.
  final String title;

  @override
  ConsumerState<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends ConsumerState<UserSearchDialog> {
  static const _minLength = 3;

  final _controller = TextEditingController();
  Timer? _debounce;
  List<UserComboModel> _results = [];
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    if (text.trim().length < _minLength) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(text.trim()));
  }

  Future<void> _search(String text) async {
    setState(() => _searching = true);
    final notifier = ref.read(userComboDataProvider.notifier);
    final found = await notifier.list(filter: ref.read(userComboDataProvider).filter.copyWith(keyword: text));
    // Only the latest search counts: the text may have changed while this one ran.
    if (!mounted || _controller.text.trim() != text) return;
    setState(() {
      _results = found;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
          title: Text(widget.title.i18n(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  labelText: "jobs_user".i18n(),
                  hintText: "jobs_user_search_hint".i18n(),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            if (_searching) const LinearProgressIndicator(),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        _controller.text.trim().length < _minLength || _searching ? "" : "jobs_user_search_none".i18n(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _results.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          ListTile(title: Text(_results[index].comboText), onTap: () => context.pop(_results[index])),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
