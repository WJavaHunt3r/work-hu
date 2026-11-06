import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/features/jobs/data/model/job_enums.dart';
import 'package:work_hu/features/jobs/data/model/job_model.dart';
import 'package:work_hu/features/jobs/widgets/job_list_item.dart';
import 'package:work_hu/features/jobs/widgets/job_marker.dart';

JobModel _job({int? max = 10, num registered = 3, bool waitlist = false, JobRegistrationStatus? mine}) => JobModel(
  id: 1,
  jobDateTime: DateTime(2026, 11, 2, 17),
  description: "Takarítás",
  employerId: 1,
  responsibleId: 1,
  account: Account.OTHER,
  transactionType: TransactionType.POINT,
  maxParticipants: max,
  registeredCount: registered,
  waitlistEnabled: waitlist,
  full: max != null && registered >= max,
  myRegistrationStatus: mine,
);

Future<void> _pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  ScreenUtilInit(
    designSize: const Size(360, 640),
    builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
  ),
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    LocalJsonLocalization.delegate.directories = ['lib/I18n'];
    await LocalJsonLocalization.delegate.load(const Locale('hu', 'HU'));
  });

  test('free places: what is left, 0 when full, null without a limit', () {
    expect(_job(max: 10, registered: 3).freePlaces, 7);
    expect(_job(max: 5, registered: 6).freePlaces, 0);
    expect(_job(max: null).freePlaces, isNull);
  });

  testWidgets('a registered user still sees the free places on the card, with the registered badge', (tester) async {
    await _pump(
      tester,
      JobListItem(
        job: _job(mine: JobRegistrationStatus.REGISTERED),
        onTap: () {},
      ),
    );

    expect(find.text("7"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.how_to_reg_outlined), findsOneWidget);
  });

  testWidgets('a registered user of a full job sees it is full', (tester) async {
    await _pump(
      tester,
      JobListItem(
        job: _job(max: 4, registered: 4, mine: JobRegistrationStatus.REGISTERED),
        onTap: () {},
      ),
    );

    expect(find.text("jobs_marker_full".i18n().toUpperCase()), findsOneWidget);
    expect(find.byIcon(Icons.how_to_reg_outlined), findsOneWidget);
  });

  testWidgets('the waitlist keeps the free places too, with the hourglass', (tester) async {
    await _pump(
      tester,
      JobMarker(job: _job(max: 4, registered: 4, waitlist: true, mine: JobRegistrationStatus.WAITLISTED)),
    );

    expect(find.text("jobs_marker_full".i18n().toUpperCase()), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_top), findsOneWidget);
  });

  testWidgets('someone not registered sees the ring without a badge', (tester) async {
    await _pump(tester, JobMarker(job: _job()));

    expect(find.text("7"), findsOneWidget);
    expect(find.byIcon(Icons.how_to_reg_outlined), findsNothing);
  });
}
