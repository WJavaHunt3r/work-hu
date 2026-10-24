import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/app/framework/base_components/paged_list/list_query.dart';
import 'package:work_hu/features/rounds/data/api/round_api.dart';
import 'package:work_hu/features/rounds/data/model/round_filter.dart';
import 'package:work_hu/features/rounds/data/repository/round_repository.dart';
import 'package:work_hu/features/rounds/data/model/round_model.dart';

Map<String, dynamic> roundJson({Map<String, dynamic> overrides = const {}}) => {
  'id': 1,
  'startDateTime': '2024-03-01T00:00:00',
  'endDateTime': '2024-03-31T23:59:00',
  'myShareGoal': 33.0,
  'localMyShareGoal': 33.0,
  'samvirkGoal': 0,
  'samvirkChurchGoal': 0,
  'roundNumber': 3,
  'freezeDateTime': '2024-03-30T23:59:00',
  'activeRound': true,
  'season': {'id': 1, 'seasonYear': 2024, 'startDate': '2024-01-01', 'endDate': '2024-12-31'},
  ...overrides,
};

void main() {
  test('a complete round is read', () {
    final round = RoundModel.fromJson(roundJson());
    expect(round.roundNumber, 3);
    expect(round.activeRound, isTrue);
  });

  test('an old round with empty optional columns is still read (the list now shows every round)', () {
    final round = RoundModel.fromJson(
      roundJson(
        overrides: {
          'localMyShareGoal': null,
          'freezeDateTime': null,
          'activeRound': null,
          'samvirkGoal': null,
          'samvirkChurchGoal': null,
        },
      ),
    );

    expect(round.activeRound, isTrue); // the column defaults to active
    expect(round.localMyShareGoal, 33); // same as the main goal
    expect(round.freezeDateTime, isNull);
  });

  test('an old round with a season without dates and a winner team without a leader is read', () {
    final round = RoundModel.fromJson(
      roundJson(
        overrides: {
          'season': {'id': 1, 'seasonYear': 2019, 'startDate': null, 'endDate': null},
          'winnerTeam': {'id': 4, 'teamLeaderId': null, 'teamName': 'Blue', 'coins': 12, 'color': null, 'active': null},
        },
      ),
    );

    expect(round.season.startDate, isNull);
    expect(round.winnerTeam!.teamName, 'Blue');
    expect(round.winnerTeam!.teamLeaderId, 0);
  });

  group('the rounds list', () {
    test('skips a round it cannot read instead of failing as a whole', () async {
      final repo = RoundRepository(
        _FakeRoundApi({
          'content': [
            roundJson(overrides: {'id': 1}),
            roundJson(overrides: {'id': 2, 'startDateTime': null}), // broken row: no start
            roundJson(overrides: {'id': 3}),
          ],
          'page': {'totalPages': 1, 'totalElements': 3, 'number': 0, 'size': 50},
        }),
      );

      final page = await repo.getRounds(const ListQuery(filter: RoundFilter()));

      expect(page.content.map((r) => r.id), [1, 3]);
    });

    test('reads a normal page as before', () async {
      final repo = RoundRepository(
        _FakeRoundApi({
          'content': [roundJson()],
          'page': {'totalPages': 1, 'totalElements': 1, 'number': 0, 'size': 50},
        }),
      );

      expect((await repo.getRounds(const ListQuery(filter: RoundFilter()))).content, hasLength(1));
    });
  });
}

class _FakeRoundApi implements RoundApi {
  _FakeRoundApi(this.answer);

  final Map<String, dynamic> answer;

  @override
  Future<dynamic> getRounds(ListQuery<RoundFilter> query, int page) async => answer;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
