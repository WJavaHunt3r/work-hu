import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';

import 'card_fill_layout.dart';

class CardFillPage extends BasePage {
  const CardFillPage({super.key, required this.userId, required this.bufeId, super.title = "card_fill", super.canPop = true});

  final num bufeId;
  final num userId;

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return CardFillLayout(id: bufeId, userId: userId);
  }
}
