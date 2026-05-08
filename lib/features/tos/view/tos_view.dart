import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ToSPage extends StatelessWidget {
  const ToSPage({super.key});

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
            child: Column(children: [
              const SizedBox(height: 20),
              // Compliance Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer, // Itt a sötétebb zöld konténer
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'tos_compliance_tag'.i18n(),
                  style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'tos_title'.i18n(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorScheme.primary, // Accent zöld
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'tos_last_updated'.i18n(),
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onBackground.withOpacity(0.5), fontSize: 13),
              ),
              const SizedBox(height: 30),

              // At a Glance Card (Light)
              _buildLightCard(
                context: context,
                theme: theme,
                titleKey: 'tos_overview_title',
                items: [
                  {'title': 'tos_integrity_title', 'body': 'tos_integrity_body'},
                  {'title': 'tos_transparency_title', 'body': 'tos_transparency_body'},
                ],
              ),

              // Acceptance Card (Dark)
              _buildDarkSection(
                context: context,
                theme: theme,
                titleKey: 'tos_acceptance_title',
                contentKey: 'tos_acceptance_body',
              ),

              // Account & Google Security Card
              _buildDarkSection(
                context: context,
                theme: theme,
                titleKey: 'tos_security_title',
                child: Column(
                  children: [
                    _buildIconRow(context, theme, Icons.g_mobiledata, 'tos_google_login_title', 'tos_google_login_body'),
                    _buildIconRow(context, theme, Icons.lock_outline, 'tos_account_security_title', 'tos_account_security_body'),
                  ],
                ),
              ),

              // Limitation of Liability
              _buildDarkSection(
                context: context,
                theme: theme,
                titleKey: 'tos_liability_title',
                contentKey: 'tos_liability_quote',
                isQuote: true,
                extraContentKey: 'tos_liability_body',
              ),

              // Footer
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('tos_footer_question'.i18n(), style: TextStyle(color: colorScheme.onPrimary)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('tos_footer_contact_btn'.i18n()),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('tos_footer_download_btn'.i18n()),
                    ),
                  ],
                ),
              )
            ])));
  }

  Widget _buildLightCard(
      {required BuildContext context,
      required ThemeData theme,
      required String titleKey,
      required List<Map<String, String>> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.visibility_outlined, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Text(titleKey.i18n(), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 15),
          ...items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!.i18n(),
                            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(item['body']!.i18n(),
                            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDarkSection(
      {required BuildContext context,
      required ThemeData theme,
      required String titleKey,
      String? contentKey,
      String? extraContentKey,
      Widget? child,
      bool isQuote = false}) {
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          // Ha eleve sötét a téma, használjuk a surface-t, ha világos, akkor egy fix sötét színt a design kedvéért
          color: isDarkTheme ? theme.colorScheme.surface : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleKey.i18n(), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          if (contentKey != null)
            Container(
              padding: isQuote ? const EdgeInsets.only(left: 12) : null,
              decoration:
                  isQuote ? BoxDecoration(border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 3))) : null,
              child: Text(
                contentKey.i18n(),
                style: TextStyle(
                  color: isQuote ? Colors.white70 : Colors.white,
                  fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
                  fontSize: 14,
                ),
              ),
            ),
          if (extraContentKey != null) ...[
            const SizedBox(height: 15),
            Text(extraContentKey.i18n(), style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildIconRow(BuildContext context, ThemeData theme, IconData icon, String titleKey, String subKey) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.primary)),
            child: Icon(Icons.check, color: theme.colorScheme.primary, size: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleKey.i18n(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subKey.i18n(), style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
