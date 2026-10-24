import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/paged_list/paged_list_page.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/models/permission.dart';
import 'package:work_hu/app/providers/user_provider.dart';
import 'package:work_hu/app/widgets/base_filter_chip.dart';
import 'package:work_hu/app/widgets/base_list_item.dart';
import 'package:work_hu/features/churches/church_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/users/providers/users_providers.dart';
import 'package:work_hu/features/users/widgets/user_create_dialog.dart';
import 'package:work_hu/features/users/widgets/user_details.dart';
import 'package:work_hu/features/utils.dart';

import '../../../app/framework/base_components/base_page_components/base_list_page.dart';

class UsersPage extends BaseListPage {
  const UsersPage({super.key, super.title = "users_title"});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UsersPageState();
  }
}

/// A choice of the church filter: one church, or the users without one.
class _ChurchChoice {
  const _ChurchChoice(this.church);

  /// Null = users without a church.
  final ChurchModel? church;

  String get label => church?.churchName ?? "users_filter_no_church".i18n();

  @override
  bool operator ==(Object other) => other is _ChurchChoice && other.church == church;

  @override
  int get hashCode => church.hashCode;
}

class UsersPageState extends PagedListPageState<UsersPage, UserComboModel, UserFilter, UsersDataNotifier> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () => notifier.setKeyword(text));
  }

  @override
  Widget buildPinnedHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.sp),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "users_search".i18n(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ListenableBuilder(
                listenable: _searchController,
                builder: (context, _) => _searchController.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged("");
                        },
                      ),
              ),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.sp)),
            ),
          ),
        ),
        super.buildPinnedHeader(),
      ],
    );
  }

  @override
  List<BaseFilterChip> buildFilterLayout(BuildContext context, WidgetRef ref) {
    final filter = state.query.filter;
    final churches = ref.watch(churchesProvider).value ?? const <ChurchModel>[];
    final choices = [const _ChurchChoice(null), for (final c in churches) _ChurchChoice(c)];
    final selectedChurch = filter.noChurch == true
        ? const _ChurchChoice(null)
        : churches.where((c) => c.id == filter.churchId).map(_ChurchChoice.new).firstOrNull;
    return [
      ModalBottomFilterChip<_ChurchChoice>(
        // Rebuilt when the churches arrive, so the chip shows the church of the starting filter
        key: ValueKey("church-${churches.length}"),
        label: "users_filter_church",
        labelValue: (choice) => choice?.label,
        initialValue: selectedChurch,
        children: choices,
        title: (choice) => Text(choice.label),
        onItemSelected: (choice) => notifier.setFilter(
          filter.copyWith(churchId: choice.church?.id, noChurch: choice.church == null ? true : null),
        ),
        onDeleted: () => notifier.setFilter(filter.copyWith(churchId: null, noChurch: null)),
      ),
      ModalBottomFilterChip<bool>(
        label: "users_filter_member",
        labelValue: (member) =>
            member == null ? null : (member ? "users_filter_members_only" : "users_filter_non_members").i18n(),
        initialValue: filter.member,
        children: const [true, false],
        title: (member) => Text((member ? "users_filter_members_only" : "users_filter_non_members").i18n()),
        onItemSelected: (member) => notifier.setFilter(filter.copyWith(member: member)),
        onDeleted: () => notifier.setFilter(filter.copyWith(member: null)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the detail state alive for the dialog, and reports its errors, which the base page doesn't.
    ref.listen(userDetailProvider, (previous, next) {
      if (next.status.modelState.isError && !(previous?.status.modelState.isError ?? false)) {
        Utils.showErrorDialog(context, content: next.status.message.i18n());
      }
    });
    return super.build(context);
  }

  @override
  Widget buildListTile(UserComboModel item, int index) {
    return BaseListTile(
      isLast: index == items.length - 1,
      index: index,
      title: Text(item.getFullName()),
      onTap: () {
        ref.read(userDetailProvider.notifier).getUser(item.id);
        showGeneralDialog(
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Theme.of(context).colorScheme.primary,
          transitionDuration: const Duration(milliseconds: 200),
          context: context,
          pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
            return UserDetails();
          },
        ).then((value) => value == true ? notifier.reload() : null);
      },
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider).user;
    if (user == null || !user.hasPermission(Permission.USER_MANAGE)) return null;
    return FloatingActionButton(
      tooltip: "user_create_title".i18n(),
      onPressed: () async {
        final created = await showDialog<bool>(context: context, builder: (_) => const UserCreateDialog());
        if (created == true) notifier.reload();
      },
      child: const Icon(Icons.person_add_alt_1),
    );
  }

  @override
  get provider => usersDataProvider;
}
