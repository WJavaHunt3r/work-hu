import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "tos_title".i18n(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          children: [
            SizedBox(height: 10.sp),
            Center(
              child: Text(
                'pp_last_updated'.i18n(),
                style: TextStyle(color: colorScheme.onSurface.withAlpha(126), fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 30.sp),

            // Google Data Section (Light Card)
            _buildInfoCard(
              context: context,
              theme: theme,
              icon: Icons.g_mobiledata,
              titleKey: 'pp_google_data_title',
              bodyKey: 'pp_google_data_body',
            ),

            // Payment Data Section (Light Card)
            _buildInfoCard(
              context: context,
              theme: theme,
              icon: Icons.credit_card,
              titleKey: 'pp_payment_data_title',
              bodyKey: 'pp_payment_data_body',
            ),

            // Usage Section (Dark Card)
            _buildDarkSection(
              context: context,
              theme: theme,
              titleKey: 'pp_usage_title',
              contentKey: 'pp_usage_body',
            ),

            // Rights Section (Dark Card)
            _buildDarkSection(
              context: context,
              theme: theme,
              titleKey: 'pp_rights_title',
              contentKey: 'pp_rights_body',
            ),

            SizedBox(height: 20.sp),

            // Footer Contact / Action
            Container(
              margin: EdgeInsets.only(bottom: 40.sp),
              padding: EdgeInsets.all(24.sp),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest, // Eltérő szín a láblécnek
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Column(
                children: [
                  Text(
                    'pp_contact_us'.i18n(),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 20.sp),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('pp_delete_account_btn'.i18n()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String titleKey,
    required String bodyKey,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15.sp),
        border: Border.all(color: theme.dividerColor.withAlpha(12)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10.sp)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24.sp),
          SizedBox(width: 16.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.i18n(),
                  style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(height: 8.sp),
                Text(
                  bodyKey.i18n(),
                  style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(200), fontSize: 13.sp, height: 1.4.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkSection({
    required BuildContext context,
    required ThemeData theme,
    required String titleKey,
    required String contentKey,
  }) {
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.sp),
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: isDarkTheme ? theme.colorScheme.surfaceContainerHighest : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleKey.i18n(),
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12.sp),
          Text(
            contentKey.i18n(),
            style: TextStyle(color: Colors.white70, fontSize: 14.sp, height: 1.5.sp),
          ),
        ],
      ),
    );
  }
}
