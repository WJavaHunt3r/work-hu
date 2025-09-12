import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/widgets/base_text_from_field.dart';

class PaymentFilter extends BasePage {
  const PaymentFilter({super.key, super.title = 'base_text_filter', super.centerTitle = true});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: BaseTextFormField(
                    labelText: 'payments_filter_dateFrom',
                  )),
                  Expanded(child: BaseTextFormField(labelText: 'payments_filter_dateTo'))
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: TextButton(onPressed: () => (), child: const Text("base_text_search")),
            ))
          ],
        )
      ],
    );
  }
}
