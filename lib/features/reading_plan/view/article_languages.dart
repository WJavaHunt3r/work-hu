import 'package:work_hu/features/streams/view/live_languages.dart';

/// The languages an article can be written in: the first is the article itself (the default, Hungarian), the others are
/// its translations. Matches the Bible translations the reader offers.
const articleLanguages = ['hu', 'en', 'de', 'nb'];

const defaultArticleLanguage = 'hu';

/// The name of a language in that language, for the selector.
String articleLanguageName(String code) => liveLanguageName(code);
