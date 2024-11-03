import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';

class BaseSearchBar extends StatelessWidget {
  const BaseSearchBar({super.key, required this.onChanged});

  final Function(String text) onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      autoFocus: true,
      hintText: "goals_search".i18n(),
      onChanged: (text) => onChanged(text),
    );
  }
}
