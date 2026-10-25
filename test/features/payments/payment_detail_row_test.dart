import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_hu/features/payment_success/view/payment_detail_row.dart';

void main() {
  testWidgets('a long checkout reference wraps instead of overflowing on a phone', (tester) async {
    // A phone 360 points wide, as on the screenshot
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 640),
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  PaymentDetailRow(label: 'Azonosító', value: 'dukapp-f4214fb7-3d40-4659-b925-12d89e93e4a1'),
                  PaymentDetailRow(label: 'Dátum és idő', value: 'Oct 25, 2026 • 08:36'),
                  PaymentDetailRow(label: 'Fizetési mód', value: 'GOOGLE_PAY', icon: Icons.g_mobiledata),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull); // no overflow
    final id = tester.getRect(find.text('dukapp-f4214fb7-3d40-4659-b925-12d89e93e4a1'));
    expect(id.right, lessThanOrEqualTo(360 - 40)); // inside the padding
    expect(id.height, greaterThan(tester.getRect(find.text('GOOGLE_PAY')).height)); // wrapped onto more lines
  });
}
