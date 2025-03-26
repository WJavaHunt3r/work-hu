import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/bufe/view/bufe_layout.dart';

class BufePage extends BasePage {
  const BufePage({super.key,this.onTrack, required this.id, super.title = "bufe", super.isListView = true});

  final num id;
  final bool? onTrack;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return BufeLayout(
      id: id, onTrack:onTrack
    );
  }
}
