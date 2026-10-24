import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

void main() {
  test('the rich text box becomes e-mail HTML with inline formatting', () {
    final document = Document.fromJson([
      {'insert': 'Hello '},
      {
        'insert': 'world',
        'attributes': {'bold': true, 'link': 'https://example.org'},
      },
      {'insert': '\n'},
      {'insert': 'first'},
      {
        'insert': '\n',
        'attributes': {'list': 'bullet'},
      },
      {'insert': 'second'},
      {
        'insert': '\n',
        'attributes': {'list': 'bullet'},
      },
    ]);

    final ops = List<Map<String, dynamic>>.from(document.toDelta().toJson());
    final html = QuillDeltaToHtmlConverter(ops, ConverterOptions.forEmail()).convert();

    expect(html, contains('Hello'));
    expect(html, contains('<strong>'));
    expect(html, contains('href="https://example.org"'));
    expect(html, contains('<li>'));
    expect(html, contains('first'));
  });
}
