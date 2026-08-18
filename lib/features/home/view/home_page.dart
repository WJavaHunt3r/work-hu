import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart' show LocalizationExtension;
import 'package:work_hu/app/framework/base_components/base_page_components/base_page.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/locator.dart';
import 'package:work_hu/app/providers/localeProvider.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_alert_dialog.dart';
import 'package:work_hu/app/widgets/base_container.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/app/widgets/base_list_view.dart';
import 'package:work_hu/app/widgets/icon_box.dart';
import 'package:work_hu/features/bufe/data/model/sumup_transactions.dart';
import 'package:work_hu/features/bufe_transaction_items/view/bufe_transaction_items_page.dart';
import 'package:work_hu/features/home/data/state/home_state.dart';
import 'package:work_hu/features/home/providers/home_provider.dart';
import 'package:work_hu/features/utils.dart';

class HomePage extends BasePage {
  HomePage({
    super.key,
  }) : super(hasAppBar: false, title: 'home_brand_name', leading: Image.asset('/assets/icons/dukapp_icon_round.png'));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends BasePageState<HomePage, HomeState, HomeDataNotifier> {
  @override
  Widget buildLayout() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeTitle(theme),
        _buildBalanceCard(theme),
        SizedBox(height: 24.sp),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(theme,
                    title: 'home_send_money'.i18n(),
                    subtitle: 'home_send_subtitle'.i18n(),
                    icon: Icons.send,
                    onTap: () {
                      context
                          .push("/balance/transfer")
                          .then((e) {
                        if (e != null && e == true) {
                          ref.read(provider.notifier).getAccount();
                        }
                      });
                    },
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    cardColor: Theme
                        .of(context)
                        .colorScheme
                        .primaryContainer)),
            SizedBox(width: 24.sp),
            Expanded(
                child: _buildActionCard(theme, onTap: () {
                  context.push("/balance/topUps");
                },
                    title: 'home_bills'.i18n(),
                    subtitle: 'home_bills_subtitle'.i18n(),
                    icon: Icons.receipt_long,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    cardColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiaryContainer)),
          ],
        ),
        SizedBox(height: 32.sp),
        if (state.familiyAccounts.isNotEmpty) _buildFamilyAccounts(theme),
        SizedBox(height: 32.sp),
        if (state.donations.isNotEmpty) _buildDonations(theme),
        _buildTransactionHeader(theme),
        SizedBox(height: 16.sp),
        _buildTransactionList(theme),
      ],
    );
  }

  // @override
  // List<Widget>? buildActions(context, ref) {
  //   return [
  //     IconButton(
  //         onPressed: () {},
  //         icon: Icon(
  //           Icons.qr_code_2,
  //           size: 24,
  //         ))
  //   ];
  // }

  Widget _buildBalanceCard(ThemeData theme) {
    return BaseContainer(
      child: Column(
        children: [
          Text('home_balance_title'.i18n(), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
          SizedBox(height: 12.sp),
          Text(Utils.creditFormatting(state.account?.balance ?? 0),
              style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 24.sp),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    context.push("/balance/topUp").then((r) {
                      if (r != null && r == true) {
                        ref.read(provider.notifier).getAccount();
                      }
                    });
                  },
                  icon: Icon(Icons.add_circle_outline, size: 20.sp),
                  label: Text('home_top_up'.i18n()),
                ),
              ),
              SizedBox(width: 24.sp),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showQrCode(context);
                  },
                  icon: Icon(Icons.grid_view, size: 20.sp),
                  label: Text('home_my_barcode'.i18n()),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionCard(ThemeData theme,
      {required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Color cardColor,
        Function? onTap}) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.all(20.sp),
        height: 180.sp,
        decoration:
        BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24.sp), border: BoxBorder.all(color: color)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(
                icon,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
              ),
            ),
            const Spacer(),
            Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.sp),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('home_recent_transactions'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        TextButton(
            onPressed: () {
              context.push("/balance/transactions");
            },
            child: Text('home_see_all'.i18n(), style: TextStyle(color: theme.colorScheme.primary))),
      ],
    );
  }

  Widget _buildTransactionList(ThemeData theme) {
    return state.orders.isEmpty
        ? const SizedBox()
        : BaseContainer(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Column(
        children: state.orders
            .map((e) =>
            _transactionItem(
                theme,
                e.locationName,
                e.date,
                e.total,
                e.locationName == "Büfé" ? Icons.coffee_outlined : Icons.shopping_bag_outlined,
                state.orders.indexOf(e),
                e.orderItems))
            .toList(),
      ),
    );
  }

  Widget _transactionItem(ThemeData theme, String name, DateTime date, num amount, IconData icon, int index,
      List<OrderItem> orderItems) {
    final locale = ref
        .watch(localeProvider)
        .value
        ?.toString() ?? 'en_US';

    // 2. Use the locale in the DateFormat constructor
    String formattedDate = DateFormat.yMEd(locale).format(date);
    return BaseListTile(
      leading: IconBox(icon: icon),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(formattedDate, style: theme.textTheme.bodySmall),
      trailing: Text("- ${Utils.creditFormatting(amount)}",
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      isLast: index == state.orders.length - 1,
      index: index,
      onTap: () =>
          showDialog(
              context: context,
              builder: (context) {
                return BufeTransactionItemsPage(items: orderItems);
              }),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<HomeDataNotifier, HomeState> get provider => homeDataProvider;

  @override
  BaseState get status => state.status;

  _showQrCode(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Theme
            .of(context)
            .colorScheme
            .surfaceContainer
            .withAlpha(200),
        builder: (buildContext) {
          return BaseAlertDialog(
            title: "home_barcode".i18n(),
            content: BaseContainer(
              color: Colors.white,
              height: 200.sp,
              child: BarcodeWidget(
                width: double.infinity,
                barcode: Barcode.code128(),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
                data: state.account?.customer_code ?? "",
              ),
            ),
            cancelVisible: false,
            confirmVisible: false,
            onTap: () {},
          );
        });
  }

  Widget _buildWelcomeTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp, bottom: 20.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('home_welcome_title'.i18n([locator<UserProvider>().user!.firstname]),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.sp),
          Text('home_welcome_subtitle'.i18n(), style: theme.textTheme.bodyMedium)
        ],
      ),
    );
  }

  _buildDonations(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('home_donations'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.sp),
        Column(
            children: state.donations.map((e) {
              return BaseContainer(
                  width: double.infinity,
                  height: 150.sp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          ref
                              .watch(localeProvider)
                              .value == const Locale("hu", "HU")
                              ? e.description.toString()
                              : e.descriptionNO.toString(),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          "${DateFormat('MMM dd, yyyy • HH:mm').format(e.startDateTime!)} - ${DateFormat('MMM dd, yyyy • HH:mm')
                              .format(e.endDateTime!)}"),
                      FilledButton(onPressed: () => context.push("/donate/${e.id}"), child: Text("home_donate".i18n()))
                    ],
                  ));
            }).toList()),
        SizedBox(height: 16.sp),
      ],
    );
  }

  _buildFamilyAccounts(ThemeData theme) {
    var items = state.familiyAccounts;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('home_family_members'.i18n(), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      SizedBox(height: 16.sp),
      BaseListView(
          hasBottomPadding: false,
          physics: const NeverScrollableScrollPhysics(),
          children: items
              .map((e) =>
              BaseListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.full_name),
                      Text(Utils.creditFormatting(e.balance),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                  isLast: items.indexOf(e) == items.length - 1,
                  index: items.indexOf(e)))
              .toList())
    ]);
  }

  @override
  void onRefresh() {
    ref.read(provider.notifier).getAccount();
  }
}
