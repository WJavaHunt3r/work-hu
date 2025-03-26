import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';
import 'package:work_hu/app/models/payment_status.dart';
import 'package:work_hu/app/providers/router_provider.dart';
import 'package:work_hu/features/card_fill/providers/card_fill_provider.dart';

import 'card_fill_layout.dart';

class CardFillPage extends BasePage {
  const CardFillPage({super.key, required this.bufeId, super.title = "card_fill", super.canPop = true});

  final num bufeId;


  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return CardFillLayout(id: bufeId);
  }
}
