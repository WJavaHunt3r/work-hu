import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/data/models/account.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/role.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/app/user_service.dart';
import 'package:work_hu/features/admin/providers/admin_provider.dart';
import 'package:work_hu/features/admin/widgets/admin_card.dart';
import 'package:work_hu/features/profile/widgets/info_card.dart';

class AdminLayout extends ConsumerWidget {
  const AdminLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = locator<UserService>().currentUser!;
    return Stack(children: [
      ListView(
        children: [
          AdminCard(
              backgroundColor: Colors.black,
              onTap: () => ref.read(adminDataProvider.notifier).createTransaction(
                  TransactionType.VAER_ET_FORBILDE,
                  Account.OTHER,
                  "${locator<UserService>().currentUser!.team!.color} csapat Vær et forbilde pontszámai"),
              imageAsset: "assets/img/forbilde.jpg"),
          user.role != Role.ADMIN
              ? const SizedBox()
              : AdminCard(
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const MyShareSplitDialog();
                      }),
                  imageAsset: "assets/img/myshare-logo-full.png"),
          user.role != Role.ADMIN
              ? const SizedBox()
              : AdminCard(
                  backgroundColor: Colors.transparent,
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const PointsSamvirkSplitDialog(
                            transactionType: TransactionType.CREDIT, account: Account.SAMVIRK);
                      }),
                  imageAsset: "assets/img/samvirk-full.png"),
          user.role != Role.ADMIN
              ? const SizedBox()
              : AdminCard(
                  backgroundColor: Colors.transparent,
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const PointsSamvirkSplitDialog(
                            transactionType: TransactionType.POINT, account: Account.OTHER);
                      }),
                  imageAsset: "assets/img/WORK_Bakgrunn_3D.jpg")
        ],
      ),
      ref.watch(adminDataProvider).modelState == ModelState.processing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(),
    ]);
  }
}

class MyShareSplitDialog extends ConsumerWidget {
  const MyShareSplitDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: AppColors.white,
            title: const Text(
              "Choose transction type",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                  )),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: ref.read(adminDataProvider.notifier).descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoCard(
                      height: 80.sp,
                      width: 80.sp,
                      onTap: ref.watch(adminDataProvider.notifier).descriptionController.value.text.isEmpty
                          ? null
                          : () {
                              ref
                                  .read(adminDataProvider.notifier)
                                  .createTransaction(TransactionType.CREDIT, Account.MYSHARE);
                              context.pop();
                            },
                      child: Icon(
                        Icons.monetization_on_outlined,
                        size: 30.sp,
                      ),
                    ),
                    InfoCard(
                      height: 80.sp,
                      width: 80.sp,
                      onTap: ref.watch(adminDataProvider.notifier).descriptionController.value.text.isEmpty
                          ? null
                          : () => ref
                              .read(adminDataProvider.notifier)
                              .createTransaction(TransactionType.HOURS, Account.MYSHARE),
                      child: Icon(Icons.hourglass_bottom_sharp, size: 30.sp),
                    )
                  ],
                ),
              ],
            )));
  }
}

class PointsSamvirkSplitDialog extends ConsumerWidget {
  const PointsSamvirkSplitDialog({required this.transactionType, required this.account, super.key});

  final TransactionType transactionType;
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            backgroundColor: AppColors.white,
            title: const Text(
              "Add a transaction description",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                  onPressed: () => context.pop(),
                  style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(color: AppColors.primary, width: 2.sp),
                    ),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  )),
              TextButton(
                  onPressed: ref.read(adminDataProvider.notifier).descriptionController.value.text.isNotEmpty
                      ? () {
                          ref.read(adminDataProvider.notifier).createTransaction(transactionType, account);
                          context.pop();
                        }
                      : null,
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                  )),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: ref.read(adminDataProvider.notifier).descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ))
                  ],
                ),
              ],
            )));
  }
}
