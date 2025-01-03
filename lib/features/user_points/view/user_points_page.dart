import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/features/user_points/view/user_points_layout.dart';

class UserPointsPage extends BasePage {
  const UserPointsPage({super.key, super.title = "user_points_title", required this.userId});

  final num userId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return UserPointsLayout(userId: userId);
  }
}
