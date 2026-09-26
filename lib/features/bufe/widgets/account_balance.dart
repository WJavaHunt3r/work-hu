import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/widgets/confirm_alert_dialog.dart';
import 'package:work_hu/features/bufe/providers/bufe_provider.dart';

class AccountBalance extends ConsumerWidget {
  const AccountBalance({super.key, required this.name, required this.balance, required this.duappId, this.onTrack, this.userId});

  final String name;
  final num balance;
  final num duappId;
  final num? userId;
  final bool? onTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Egyenleged"),
              Padding(
                  padding: EdgeInsets.only(bottom: 8.sp),
                  child: Text(
                    "$balance Ft",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800),
                  )),
            ],
          ),
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
                            context.push("/profile/bufe/$duappId/cardFill").then((value) {
                              ref.watch(bufeDataProvider.notifier).getAccounts(duappId);
                            });
                          },
                          title: "card_fill_confirm".i18n(),
                          content: Text("card_fill_confirm_text".i18n()));
                    });
              } else {
                context.push("/profile/bufe/$duappId/cardFill").then((value) {
                  ref.watch(bufeDataProvider.notifier).getAccounts(duappId);
                });
              }
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Icon(
                  Icons.add,
                  size: 36.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
