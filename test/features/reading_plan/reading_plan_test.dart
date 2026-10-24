import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/features/reading_plan/data/model/bible_translation.dart';
import 'package:work_hu/features/reading_plan/data/model/reading_plan_model.dart';
import 'package:work_hu/features/reading_plan/providers/reading_plan_provider.dart';
import 'package:work_hu/features/reading_plan/view/article_body.dart';

ReadingPlanModel plan({Set<int> items = const {}}) => ReadingPlanModel.fromJson({
  'id': 1,
  'title': 'Zsoltárok olvasási terv',
  'bookKey': 'Ps',
  'itemCount': 150,
  'startDate': '2026-10-21',
  'endDate': '2026-11-13',
  'description': '',
  'open': true,
  'weeks': [
    {'weekNumber': 1, 'startItem': 1, 'endItem': 38, 'startsOn': '2026-10-21', 'endsOn': '2026-10-27'},
    {'weekNumber': 2, 'startItem': 39, 'endItem': 76, 'startsOn': '2026-10-28', 'endsOn': '2026-11-03'},
    {'weekNumber': 3, 'startItem': 77, 'endItem': 113, 'startsOn': '2026-11-04', 'endsOn': '2026-11-09'},
    {'weekNumber': 4, 'startItem': 114, 'endItem': 150, 'startsOn': '2026-11-10', 'endsOn': '2026-11-13'},
  ],
  'myItems': items.toList(),
  'participants': 3,
  'totalReadings': 20,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReadingPlanModel', () {
    test('picks the week of a day, the first before the plan and the last after it', () {
      final p = plan();
      expect(p.weekOn(DateTime(2026, 10, 21))!.weekNumber, 1);
      expect(p.weekOn(DateTime(2026, 11, 3, 23, 59))!.weekNumber, 2);
      expect(p.weekOn(DateTime(2026, 11, 13))!.weekNumber, 4);
      expect(p.weekOn(DateTime(2026, 10, 1))!.weekNumber, 1);
      expect(p.weekOn(DateTime(2027, 1, 1))!.weekNumber, 4);
    });

    test('counts progress per week and overall', () {
      final p = plan(items: {1, 2, 38, 39, 150});
      expect(p.readCount, 5);
      expect(p.remaining, 145);
      expect(p.readIn(p.weeks[0]), 3);
      expect(p.readIn(p.weeks[1]), 1);
      expect(p.weeks[3].size, 37);
    });

    test('finds the first unread item, or none when all are read', () {
      expect(plan(items: {1, 2, 4}).nextUnread, 3);
      expect(plan(items: {for (var i = 1; i <= 150; i++) i}).nextUnread, isNull);
    });

    test('counts the days left including today', () {
      expect(plan().daysLeft(DateTime(2026, 11, 13, 18)), 1);
      expect(plan().daysLeft(DateTime(2026, 10, 21)), 24);
    });

    test('withItems keeps everything else', () {
      final p = plan().withItems({5});
      expect(p.myItems, {5});
      expect(p.title, 'Zsoltárok olvasási terv');
      expect(p.weeks.length, 4);
    });
  });

  group('bundled translations', () {
    for (final t in bibleTranslations) {
      test('${t.shortName} has all 150 psalms with numbered verses', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final psalms = await container.read(psalmTextProvider(t.id).future);

        expect(psalms.length, 150);
        expect(psalms[119]!.length, 176);
        expect(psalms.values.every((verses) => verses.isNotEmpty && verses.first.number == 1), isTrue);
      });
    }

    test('the first lines are the expected text of each translation', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect((await container.read(psalmTextProvider('kar').future))[1]!.first.text, startsWith('Boldog ember'));
      expect((await container.read(psalmTextProvider('web').future))[1]!.first.text, startsWith('Blessed is the man'));
      expect((await container.read(psalmTextProvider('kjv').future))[1]!.first.text, startsWith('Blessed is the man'));
      expect((await container.read(psalmTextProvider('luth1912').future))[1]!.first.text, startsWith('Wohl dem'));
      expect(
        (await container.read(psalmTextProvider('nb1930').future))[1]!.first.text,
        startsWith('Salig er den mann'),
      );
    });

    test('the app language picks the default, and a user pick wins', () {
      expect(defaultTranslationFor('hu').id, 'kar');
      expect(defaultTranslationFor('en').id, 'web');
      expect(defaultTranslationFor('de').id, 'luth1912'); // for when the app gets more languages
      expect(defaultTranslationFor('fr').id, 'kar');
      expect(translationById('kjv').shortName, 'KJV');
      expect(translationById('nope').id, 'kar');
    });
  });

  test('every translation placeholder is one the localization package replaces (%s, %s0, %s1 ...)', () {
    for (final file in ['lib/I18n/hu_HU.json', 'lib/I18n/en_US.json']) {
      final texts = jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
      for (final entry in texts.entries) {
        expect(RegExp(r'\{\d\}').hasMatch('${entry.value}'), isFalse, reason: '$file ${entry.key} uses {0}, use %s0');
      }
    }
  });

  group('article text', () {
    test('a stored delta becomes a document and back, and an empty one is stored as nothing', () {
      const body = '[{"insert":"Hello "},{"insert":"world","attributes":{"bold":true}},{"insert":"\\n"}]';

      final document = articleDocument(body);

      expect(document.toPlainText().trim(), 'Hello world');
      expect(articleBodyOf(document), contains('"bold":true'));
      expect(articleBodyOf(articleDocument(null)), isNull);
      expect(articleBodyOf(articleDocument('[{"insert":"  \\n"}]')), isNull);
    });

    test('text that cannot be read gives an empty document instead of an error', () {
      expect(articleDocument('not json').toPlainText().trim(), isEmpty);
      expect(articleDocument('{"insert":"x"}').toPlainText().trim(), isEmpty);
    });
  });

  test('an article is read from the backend answer, with or without text', () {
    final list = ReadingArticle.fromJson({
      'id': 3,
      'title': 'T',
      'points': 4,
      'read': true,
      'published': true,
      'createdDateTime': '2026-10-22T10:00:00',
    });
    final one = ReadingArticle.fromJson({
      'id': 3,
      'title': 'T',
      'points': 4,
      'read': false,
      'published': false,
      'body': '[]',
    });

    expect(list.body, isNull);
    expect(list.read, isTrue);
    expect(list.createdDateTime!.year, 2026);
    expect(one.body, '[]');
    expect(one.published, isFalse);
  });

  test('the ranking is read with points, and from an older backend without them', () {
    final newer = LeaderboardModel.fromJson({
      'entries': [
        {'rank': 1, 'userId': 5, 'name': 'A B', 'count': 14, 'articlePoints': 5},
      ],
      'total': 1,
      'myRank': 1,
      'myCount': 9,
      'myPoints': 14,
      'myArticlePoints': 5,
    });
    final older = LeaderboardModel.fromJson({
      'entries': [
        {'rank': 1, 'userId': 5, 'name': 'A B', 'count': 9},
      ],
      'total': 1,
      'myRank': 1,
      'myCount': 9,
    });

    expect(newer.myPoints, 14);
    expect(newer.entries.single.articlePoints, 5);
    expect(older.myPoints, 9); // the points were the items
    expect(older.entries.single.articlePoints, 0);
  });
}
