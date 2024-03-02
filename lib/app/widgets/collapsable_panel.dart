import 'package:flutter/material.dart';

class CollapsablePanel extends StatelessWidget {
  const CollapsablePanel({super.key, required this.expansionCallback, required this.panels});

  final Function(int, bool) expansionCallback;
  final List<ExpansionPanel> panels;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList(
        expansionCallback: expansionCallback,
        elevation: 0,
        children: panels,
      ),
    ));
  }
}
