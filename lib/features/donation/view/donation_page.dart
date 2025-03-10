import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_hu/app/framework/base_components/base_page.dart';

import 'donation_layout.dart';

class DonationPage extends BasePage{
  const DonationPage({super.key, super.title="donation"});

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return DonationLayout();
  }

}