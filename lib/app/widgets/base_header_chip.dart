import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

class BaseHeaderChip extends StatelessWidget {
  BaseHeaderChip({
    super.key,
    required this.label,
    required this.labelValue,
  });

  final String label;
  final Future<String> Function() labelValue;
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: labelValue(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // String value = "";
          // if (snapshot.connectionState == ConnectionState.waiting) {
          // }
          // if (snapshot.hasError) {
          //   return Center(child: Text('Error loading data: ${snapshot.error}'));
          // }
          String value = snapshot.data ?? "";
          return value.isNotEmpty
              ? Tooltip(
                  key: tooltipKey,
                  triggerMode: TooltipTriggerMode.manual,
                  message: "header_label".i18n([(label.i18n()), value]),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.sp),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 800.sp),
                      child: FilterChip(
                          label: Text(
                            value,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          backgroundColor: Theme.of(context).chipTheme.shape?.side.color,
                          onSelected: (value) {
                            final TooltipState? tooltip = tooltipKey.currentState;
                            tooltip?.ensureTooltipVisible();
                          },
                          avatar: const Icon(Icons.open_in_new_outlined)),
                    ),
                  ),
                )
              : const SizedBox();
        });
  }
}
