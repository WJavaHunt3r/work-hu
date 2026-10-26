import 'package:flutter/widgets.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

/// The web build's phone-sized frame (`FlutterWebFrame`, at most 500 x 1000). That package hands the app a
/// MediaQuery with `viewInsets` set to zero, so in a phone browser nothing (pages, bottom sheets) made room for the
/// on-screen keyboard and it covered the text fields (job chat, shared notes). This puts the real insets back.
class KeyboardAwareWebFrame extends StatelessWidget {
  const KeyboardAwareWebFrame({super.key, required this.builder, this.backgroundColor});

  final WidgetBuilder builder;
  final Color? backgroundColor;

  static const maximumSize = Size(500, 1000);

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context);
    return FlutterWebFrame(
      backgroundColor: backgroundColor,
      maximumSize: maximumSize,
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(viewInsets: keyboard),
        child: Builder(builder: builder),
      ),
    );
  }
}
