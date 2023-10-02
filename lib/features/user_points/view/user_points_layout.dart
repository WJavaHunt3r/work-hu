import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/data/models/transaction_type.dart';
import 'package:work_hu/app/style/app_colors.dart';
import 'package:work_hu/features/user_points/provider/user_points_providers.dart';

class UserPointsLayout extends ConsumerWidget {
  const UserPointsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ListView.separated(
          itemCount: ref.watch(userPointsDataProvider).transactionItems.length,
          itemBuilder: (BuildContext context, int index) {
            var current = ref.watch(userPointsDataProvider).transactionItems[index];
            return PointsListItem(
                transactionType: current.transactionType,
                value: current.points,
                title: current.description,
                date: current.transactionDate);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp, bottom: 10.sp),
                child: Container(
                  height: 1.5.sp,
                  color: AppColors.primary,
                ));
          },
        )
      ],
    );
  }
}

class PointsListItem extends StatelessWidget {
  const PointsListItem(
      {required this.transactionType, super.key, required this.value, required this.title, required this.date});

  final TransactionType transactionType;
  final num value;
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 12.sp, right: 12.sp),
        child: SizedBox(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              )),
              Text(
                 value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: 60.sp,
                  child: Text(
                      "${date.month < 10 ? "0${date.month}" : date.month}.${date.day < 10 ? "0${date.day}" : date.day}",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500))),
            ],
          )
        ])));
  }
}
