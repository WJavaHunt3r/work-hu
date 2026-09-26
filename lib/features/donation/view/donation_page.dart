import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';

import 'donation_layout.dart';

class DonationsPage extends LegacyBasePage {
  const DonationsPage({super.key, super.title = "donations"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return DonationsLayout();
  }
}
