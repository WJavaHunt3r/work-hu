/// A Bible translation bundled in the app: one JSON file with all 150 psalms in `assets/bible/`
/// (`{"chapters": [{"chapter": 1, "verses": [{"number": 1, "text": "..."}]}]}`).
/// To add a translation, drop its file there and list it in [bibleTranslations]; it must be free to redistribute.
class BibleTranslation {
  const BibleTranslation({
    required this.id,
    required this.shortName,
    required this.name,
    required this.languageCode,
    required this.asset,
  });

  final String id;

  /// Shown in the reader's translation button.
  final String shortName;

  /// Full name with the year, shown above the text.
  final String name;
  final String languageCode;
  final String asset;
}

const bibleTranslations = <BibleTranslation>[
  BibleTranslation(
    id: 'kar',
    shortName: 'Károli',
    name: 'Károli Gáspár – revideált fordítás (1908)',
    languageCode: 'hu',
    asset: 'assets/bible/karoli_psalms.json',
  ),
  BibleTranslation(
    id: 'web',
    shortName: 'WEB',
    name: 'World English Bible (public domain)',
    languageCode: 'en',
    asset: 'assets/bible/web_psalms.json',
  ),
  BibleTranslation(
    id: 'kjv',
    shortName: 'KJV',
    name: 'King James Version (1769, public domain)',
    languageCode: 'en',
    asset: 'assets/bible/kjv_psalms.json',
  ),
  BibleTranslation(
    id: 'luth1912',
    shortName: 'Luther',
    name: 'Lutherbibel (1912, public domain)',
    languageCode: 'de',
    asset: 'assets/bible/luther1912_psalms.json',
  ),
  BibleTranslation(
    id: 'elb1905',
    shortName: 'Elberfelder',
    name: 'Elberfelder Bibel (1905, public domain)',
    languageCode: 'de',
    asset: 'assets/bible/elberfelder1905_psalms.json',
  ),
  BibleTranslation(
    id: 'nb1930',
    shortName: 'Norsk',
    name: 'Norsk Bibel (1930, public domain)',
    languageCode: 'nb',
    asset: 'assets/bible/norsk1930_psalms.json',
  ),
];

/// The translation to start with for an app language: the first one in that language, else the first one.
BibleTranslation defaultTranslationFor(String? languageCode) =>
    bibleTranslations.firstWhere((t) => t.languageCode == languageCode, orElse: () => bibleTranslations.first);

BibleTranslation translationById(String? id) =>
    bibleTranslations.firstWhere((t) => t.id == id, orElse: () => bibleTranslations.first);

/// The Book of Psalms' name and short name in a translation's language (the bundled files have no book names).
({String name, String abbreviation}) psalmsBookName(String languageCode) => switch (languageCode) {
  'hu' => (name: 'Zsoltárok', abbreviation: 'Zsolt'),
  'de' => (name: 'Psalmen', abbreviation: 'Ps'),
  'nb' => (name: 'Salmene', abbreviation: 'Sal'),
  _ => (name: 'Psalms', abbreviation: 'Ps'),
};

/// The psalms whose title counts as verse 1 in Károli and Norsk (verse numbering label "heb" in the backend's full
/// Bible files, see scripts/bible/build_bible.py); every other psalm, and every psalm in the other translations, is
/// numbered like KJV ("kjv").
const _titledPsalms = {
  3, 4, 5, 6, 7, 8, 9, 12, 18, 19, 20, 21, 22, 30, 31, 34, 36, 38, 39, 40, 41, 42, 44, 45, 46, 47, 48, 49, 51, 52, //
  53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 67, 68, 69, 70, 75, 76, 77, 80, 81, 83, 84, 85, 88, 89, 92, //
  102, 108, 140, 142,
};
const _titleIsVerse = {'kar', 'nb1930'};

/// The verse numbering label of [psalm] in [translationId]: highlights and notes are shown where it is the same.
String psalmNumbering(String translationId, int psalm) =>
    _titleIsVerse.contains(translationId) && _titledPsalms.contains(psalm) ? 'heb' : 'kjv';
