import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                'pp_last_updated'.i18n(),
                style: TextStyle(color: colorScheme.onBackground.withOpacity(0.5), fontSize: 13),
              ),
            ),
            const SizedBox(height: 30),

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

            const SizedBox(height: 20),

            // Footer Contact / Action
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant, // Eltérő szín a láblécnek
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'pp_contact_us'.i18n(),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.i18n(),
                  style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  bodyKey.i18n(),
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 13, height: 1.4),
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
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkTheme ? theme.colorScheme.surfaceVariant : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleKey.i18n(),
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            contentKey.i18n(),
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
