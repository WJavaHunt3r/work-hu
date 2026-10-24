import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/api_exception.dart';
import 'package:work_hu/app/platform/adaptive.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/article_body.dart';
import 'package:work_hu/features/reading_plan/view/article_languages.dart';

/// The title and text of an article in one language, kept while the editor switches between languages.
class _Draft {
  final title = TextEditingController();
  QuillController body = QuillController.basic();

  /// Whether the saved text of this language has been fetched (the default language is loaded with the article).
  bool loaded = false;

  void dispose() {
    title.dispose();
    body.dispose();
  }

  void fill(String title, String? text) {
    this.title.text = title;
    body.dispose();
    body = QuillController(document: articleDocument(text), selection: const TextSelection.collapsed(offset: 0));
    loaded = true;
  }
}

/// Admin → Reading plan → one article. The Hungarian text is the article itself (title, extra points, published
/// switch); the other languages are translations of its title and text, which readers get when their app language
/// matches. A rich text editor (text copied from Word keeps its basic formatting) writes the text. A draft is only seen
/// by the people who manage the plan.
class ArticleEditPage extends ConsumerStatefulWidget {
  const ArticleEditPage({super.key, this.id});

  /// Null when writing a new article.
  final num? id;

  @override
  ConsumerState<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends ConsumerState<ArticleEditPage> {
  final _points = TextEditingController(text: '1');
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _drafts = {for (final l in articleLanguages) l: _Draft()};

  /// Languages that have saved text (the default one once the article exists).
  final _existing = <String>{};
  late num? _id = widget.id;
  String _language = defaultArticleLanguage;
  bool _published = false;
  bool _loading = true;
  bool _saving = false;

  bool get _isNew => _id == null;
  bool get _isDefault => _language == defaultArticleLanguage;
  _Draft get _draft => _drafts[_language]!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _points.dispose();
    _focus.dispose();
    _scroll.dispose();
    for (final d in _drafts.values) {
      d.dispose();
    }
    super.dispose();
  }

  num _planId() {
    final plan = ref.read(readingPlanProvider).plan;
    if (plan == null) throw StateError('no plan');
    return plan.id;
  }

  /// Waits until the plan is loaded (this page may have been opened directly; the provider is rebuilt once the app
  /// language is known).
  Future<void> _planLoaded() async {
    for (var attempt = 0; attempt < 3 && ref.read(readingPlanProvider).plan == null; attempt++) {
      await ref.read(readingPlanProvider.notifier).firstLoad;
    }
  }

  Future<void> _load() async {
    if (_isNew) {
      setState(() => _loading = false);
      return;
    }
    try {
      await _planLoaded();
      final article = await ref.read(readingPlanRepoProvider).getAnyArticle(_planId(), _id!);
      if (!mounted) return;
      _drafts[defaultArticleLanguage]!.fill(article.title, article.body);
      _points.text = article.points.toString();
      _published = article.published;
      _existing
        ..clear()
        ..addAll(article.languages.isEmpty ? [defaultArticleLanguage] : article.languages);
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      showApiError("api_unknown_error".i18n());
      context.pop();
    }
  }

  /// Switches the language being edited, fetching its saved translation the first time.
  Future<void> _select(String language) async {
    if (language == _language) return;
    setState(() => _language = language);
    final draft = _drafts[language]!;
    if (draft.loaded || _isNew || language == defaultArticleLanguage) return;
    try {
      final saved = await ref.read(readingPlanRepoProvider).getArticleTranslation(_planId(), _id!, language);
      if (!mounted) return;
      setState(() {
        if (saved != null) {
          draft.fill(saved.title, saved.body);
        } else {
          draft.loaded = true;
        }
      });
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  void _saved() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("reading_plan_admin_saved".i18n())));
  }

  Future<void> _save() async {
    final title = _draft.title.text.trim();
    final points = int.tryParse(_points.text.trim());
    if (title.isEmpty || (_isDefault && (points == null || points < 1 || points > 100))) {
      showApiError("reading_plan_admin_invalid".i18n());
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(readingPlanRepoProvider);
      final body = articleBodyOf(_draft.body.document);
      if (_isDefault) {
        final saved = await repo.saveArticle(
          _planId(),
          _id,
          title: title,
          body: body,
          points: points!,
          published: _published,
        );
        _id = saved.id;
        _existing.add(defaultArticleLanguage);
      } else {
        await repo.saveArticleTranslation(_planId(), _id!, _language, title: title, body: body);
        _existing.add(_language);
      }
      if (mounted) _saved();
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _confirm(String titleKey, String question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AdaptiveAlertDialog(
        title: Text(titleKey.i18n()),
        content: Text(question),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text("base_cancel".i18n())),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(titleKey.i18n())),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _deleteArticle() async {
    if (!await _confirm(
      "reading_plan_admin_delete",
      "reading_plan_admin_delete_question".i18n([_drafts[defaultArticleLanguage]!.title.text.trim()]),
    )) {
      return;
    }
    try {
      await ref.read(readingPlanRepoProvider).deleteArticle(_planId(), _id!);
      if (mounted) context.pop(true);
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  Future<void> _deleteTranslation() async {
    final name = articleLanguageName(_language);
    final question = "reading_plan_admin_delete_translation_question".i18n([name]);
    if (!await _confirm("reading_plan_admin_delete_translation", question)) {
      return;
    }
    try {
      await ref.read(readingPlanRepoProvider).deleteArticleTranslation(_planId(), _id!, _language);
      if (!mounted) return;
      setState(() {
        _existing.remove(_language);
        _draft.fill('', null);
      });
    } on ApiException catch (e) {
      showApiError(e.message);
    } catch (_) {
      showApiError("api_unknown_error".i18n());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Keeps the plan loaded while this page is open (it is needed to save), also when opened directly
    ref.watch(readingPlanProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_isNew ? "reading_plan_admin_new" : "reading_plan_admin_edit").i18n(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isNew)
            IconButton(
              tooltip: "reading_plan_admin_delete".i18n(),
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              onPressed: _saving ? null : _deleteArticle,
            ),
          TextButton(onPressed: _saving || _loading ? null : _save, child: Text("reading_plan_admin_save".i18n())),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: EdgeInsets.all(16.sp),
              children: [
                Text(
                  "reading_plan_admin_language".i18n(),
                  style: theme.textTheme.labelLarge?.copyWith(color: theme.hintColor),
                ),
                SizedBox(height: 8.sp),
                Wrap(
                  spacing: 8.sp,
                  runSpacing: 8.sp,
                  children: [
                    for (final l in articleLanguages)
                      ChoiceChip(
                        avatar: _existing.contains(l) ? const Icon(Icons.check, size: 16) : null,
                        label: Text(articleLanguageName(l)),
                        selected: l == _language,
                        // Translations need the article to exist first
                        onSelected: l == defaultArticleLanguage || !_isNew ? (_) => _select(l) : null,
                      ),
                  ],
                ),
                if (_isNew)
                  Padding(
                    padding: EdgeInsets.only(top: 6.sp),
                    child: Text(
                      "reading_plan_admin_save_first".i18n(),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                  ),
                if (!_isDefault && !_existing.contains(_language))
                  Padding(
                    padding: EdgeInsets.only(top: 6.sp),
                    child: Text(
                      "reading_plan_admin_translation_none".i18n(),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    ),
                  ),
                SizedBox(height: 12.sp),
                TextField(
                  key: ValueKey('title-$_language'),
                  controller: _draft.title,
                  maxLength: 200,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "reading_plan_admin_article_title".i18n(), counterText: ""),
                ),
                if (_isDefault) ...[
                  SizedBox(height: 12.sp),
                  TextField(
                    controller: _points,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: "reading_plan_admin_points".i18n(),
                      helperText: "reading_plan_admin_points_hint".i18n(),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text("reading_plan_admin_published".i18n()),
                    subtitle: Text("reading_plan_admin_published_hint".i18n()),
                    value: _published,
                    onChanged: (value) => setState(() => _published = value),
                  ),
                ],
                SizedBox(height: 8.sp),
                QuillSimpleToolbar(
                  key: ValueKey('toolbar-$_language'),
                  controller: _draft.body,
                  config: const QuillSimpleToolbarConfig(
                    multiRowsDisplay: true,
                    showFontFamily: false,
                    showFontSize: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showInlineCode: false,
                    showCodeBlock: false,
                    showSearchButton: false,
                    showIndent: false,
                    showDirection: false,
                    showQuote: true,
                    showListCheck: false,
                  ),
                ),
                SizedBox(height: 8.sp),
                Container(
                  height: 420.sp,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: QuillEditor(
                    key: ValueKey('editor-$_language'),
                    controller: _draft.body,
                    focusNode: _focus,
                    scrollController: _scroll,
                    config: QuillEditorConfig(placeholder: "reading_plan_admin_body_hint".i18n(), expands: true),
                  ),
                ),
                if (!_isDefault && _existing.contains(_language))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _saving ? null : _deleteTranslation,
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                      label: Text(
                        "reading_plan_admin_delete_translation".i18n(),
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
