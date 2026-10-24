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
