import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(children: [
              SizedBox(height: 20.sp),
              // Compliance Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer, // Itt a sötétebb zöld konténer
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Text(
                  'tos_compliance_tag'.i18n(),
                  style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.sp),
              Text(
                'tos_title'.i18n(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colorScheme.primary, // Accent zöld
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.sp),
              Text(
                'tos_last_updated'.i18n(),
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onBackground.withAlpha(125), fontSize: 13.sp),
              ),
              SizedBox(height: 30.sp),

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
                margin: EdgeInsets.only(bottom: 40.sp),
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Column(
                  children: [
                    Text('tos_footer_question'.i18n(), style: TextStyle(color: colorScheme.onPrimary)),
                    SizedBox(height: 20.sp),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('tos_footer_contact_btn'.i18n()),
                    ),
                    SizedBox(height: 10.sp),
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
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10.sp)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.visibility_outlined, color: theme.colorScheme.primary, size: 18.sp),
            SizedBox(width: 8.sp),
            Text(titleKey.i18n(), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 15.sp),
          ...items
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!.i18n(),
                            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(item['body']!.i18n(),
                            style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(140), fontSize: 12)),
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
      padding: EdgeInsets.all(24.sp),
      margin: EdgeInsets.only(bottom: 20.sp),
      decoration: BoxDecoration(
          // Ha eleve sötét a téma, használjuk a surface-t, ha világos, akkor egy fix sötét színt a design kedvéért
          color: isDarkTheme ? theme.colorScheme.surface : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(15.sp)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleKey.i18n(), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 15.sp),
          if (contentKey != null)
            Container(
              padding: isQuote ? EdgeInsets.only(left: 12.sp) : null,
              decoration:
                  isQuote ? BoxDecoration(border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 3))) : null,
              child: Text(
                contentKey.i18n(),
                style: TextStyle(
                  color: isQuote ? Colors.white70 : Colors.white,
                  fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
                  fontSize: 14.sp,
                ),
              ),
            ),
          if (extraContentKey != null) ...[
            SizedBox(height: 15.sp),
            Text(extraContentKey.i18n(), style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
          ],
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildIconRow(BuildContext context, ThemeData theme, IconData icon, String titleKey, String subKey) {
    return Padding(
      padding: EdgeInsets.only(top: 15.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.primary)),
            child: Icon(Icons.check, color: theme.colorScheme.primary, size: 12.sp),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleKey.i18n(), style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text(subKey.i18n(), style: TextStyle(color: Colors.white60, fontSize: 12.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
