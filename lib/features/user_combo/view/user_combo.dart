import 'package:flutter/material.dart';
import 'package:work_hu/app/widgets/work_drop_down_dearch_form_field.dart';
import 'package:work_hu/features/user_combo/data/model/user_combo_model.dart';
import 'package:work_hu/features/user_combo/data/model/user_filter.dart';
import 'package:work_hu/features/user_combo/provider/user_combo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserComboWidget extends ConsumerStatefulWidget {
  const UserComboWidget(
      {super.key,
      required this.onSuggestionSelected,
      this.filter,
      this.fldControl,
      this.initValue,
      this.autofocus = false,
      required this.labelText,
      required this.controller,
      this.focusNode});

  final UserFilter? filter;
  final String? fldControl;
  final num? initValue;
  final bool autofocus;
  final String labelText;
  final FocusNode? focusNode;
  final TextEditingController controller;

  final Function(UserComboModel user) onSuggestionSelected;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserComboComboWidgetState();
  }
}

class UserComboComboWidgetState extends ConsumerState<UserComboWidget> {
  late TextEditingController _saveController;
  late bool _hasTapped;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _saveController = TextEditingController();
    _hasTapped = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initValue != null) {
        getUser();
      }
    });
  }

  Future<void> getUser() async {
    var res = await ref.read(userComboDataProvider.notifier).getUser(id: widget.initValue!);
    if (res != null) {
      onSuggestionSelected(res);
    }
  }

  void onTappedChanged(TextEditingController controller) {
    setState(() {
      if (!_hasTapped) {
        widget.controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller.value.text.length);
      }
      _hasTapped = !_hasTapped;
    });
  }

  final bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Focus(
            focusNode: widget.focusNode ?? FocusNode(),
            child: DropDownSearchFormField<UserComboModel>(
                getLabel: (u) => u.comboText,
                fldControl: widget.fldControl,
                onTap: (controller) {
                  onTappedChanged(controller);
                },
                focusNode: focusNode,
                enabled: (widget.fldControl == null || widget.fldControl != "2" || widget.fldControl != "3") && _enabled,
                controller: widget.controller,
                labelText: widget.labelText,
                onSuggestionSelected: (article) {
                  onSuggestionSelected(article);
                },
                // onSuggestionsBoxToggle: (toggled) => !toggled ? _controller.text = _saveController.text : null,
                itemBuilder: (itemContext, charge) {
                  return Text(charge.comboText, style: Theme.of(context).textTheme.bodyMedium);
                },
                suggestionsCallback: (searchText) async {
                  await Future.delayed(Duration.zero);
                  return await ref.read(userComboDataProvider.notifier).list(
                      filter: widget.filter?.copyWith(keyword: searchText) ??
                          ref.read(userComboDataProvider).filter.copyWith(keyword: searchText));
                }),
          ),
        ),
      ],
    );
  }

  void onSuggestionSelected(UserComboModel user) {
    widget.controller.text = user.comboText;
    _saveController.text = user.comboText;
    widget.onSuggestionSelected(user);
  }

  @override
  void dispose() {
    _saveController.dispose();
    super.dispose();
  }
}
