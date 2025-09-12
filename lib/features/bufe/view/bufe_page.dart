import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/bufe/view/bufe_layout.dart';

class BufePage extends BasePage {
  const BufePage({super.key, this.onTrack, required this.userId, required this.id, super.title = "", super.isListView = true});

  final num id;
  final bool? onTrack;
  final num userId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return BufeLayout(
      id: id,
      onTrack: onTrack,
      userId: userId,
    );
  }
}
