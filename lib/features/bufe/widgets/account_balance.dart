import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

class AccountBalance extends ConsumerWidget {
  const AccountBalance({super.key, required this.name, required this.balance, required this.id, this.onTrack});

  final String name;
  final String balance;
  final num id;
  final bool? onTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: Text(
              "${balance.replaceAll(".00", "")} Ft",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
            )),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  if (onTrack != null && !onTrack!) {
                    showDialog(
                        context: context,
                        barrierColor: AppColors.redRowBgColor,
                        barrierDismissible: false,
                        builder: (context) {
                          return ConfirmAlertDialog(
                              icon: Icon(
                                Icons.cancel,
                                size: 40.sp,
                                color: AppColors.errorRed,
                              ),
                              onConfirm: () {
                                context.pop();
                                context.push("/profile/bufe/$id/cardFill", extra: {"bufeId": id}).then((value) {
                                  ref.watch(bufeDataProvider.notifier).getAccount(id);
                                });
                              },
                              title: "card_fill_confirm".i18n(),
                              content: Text("card_fill_confirm_text".i18n()));
                        });
                  } else {
                    context.push("/profile/bufe/$id/cardFill", extra: {"bufeId": id}).then((value) {
                      ref.watch(bufeDataProvider.notifier).getAccount(id);
                    });
                  }
                },
                icon: Icon(Icons.add)),
            Text("card_fill_button".i18n())
          ],
        ),
      ],
    );
  }
}
