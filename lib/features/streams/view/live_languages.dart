/// Languages an admin can give a stream, as the code stored with it and the name shown in that language (so a
/// listener finds theirs). Unknown codes are shown in capitals.
const liveLanguages = <String, String>{
  'hu': 'Magyar',
  'en': 'English',
  'de': 'Deutsch',
  'ro': 'Română',
  'sk': 'Slovenčina',
  'uk': 'Українська',
  'ru': 'Русский',
  'sr': 'Srpski',
  'hr': 'Hrvatski',
  'nb': 'Norsk',
};

String liveLanguageName(String code) => code.isEmpty ? '' : (liveLanguages[code.toLowerCase()] ?? code.toUpperCase());
