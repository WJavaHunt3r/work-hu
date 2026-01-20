import 'package:flutter/material.dart';

class HeaderChipLayout extends StatelessWidget {
  final List<Widget> Function(BuildContext) buildChildren;

  const HeaderChipLayout({super.key, required this.buildChildren});

  @override
  Widget build(BuildContext context) {
    var widgets = buildChildren(context);
    return widgets.isEmpty
        ? const SizedBox()
        : Expanded(
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        ...widgets,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
