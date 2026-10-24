import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';

/// The Quill document of an article's text (a delta stored as JSON text); an empty document when there is none or it
/// can't be read.
Document articleDocument(String? body) {
  if (body == null || body.trim().isEmpty) return Document();
  try {
    return Document.fromJson(jsonDecode(body) as List<dynamic>);
  } catch (_) {
    return Document();
  }
}

/// The text to store for a document: the delta as JSON, or null when it only holds whitespace.
String? articleBodyOf(Document document) {
  if (document.toPlainText().trim().isEmpty) return null;
  return jsonEncode(document.toDelta().toJson());
}

/// An article's text, read only. Links open in the browser, only http, https and mailto ones.
class ArticleBody extends StatefulWidget {
  const ArticleBody({super.key, required this.body});

  final String? body;

  @override
  State<ArticleBody> createState() => _ArticleBodyState();
}

class _ArticleBodyState extends State<ArticleBody> {
  late final QuillController _controller = QuillController(
    document: articleDocument(widget.body),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: true,
  );
  final _focus = FocusNode(canRequestFocus: false);
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !const {'http', 'https', 'mailto'}.contains(uri.scheme)) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: _controller,
      focusNode: _focus,
      scrollController: _scroll,
      config: QuillEditorConfig(scrollable: false, showCursor: false, padding: EdgeInsets.zero, onLaunchUrl: _open),
    );
  }
}
