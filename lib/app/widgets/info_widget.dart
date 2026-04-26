import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget(
      {super.key, required this.infoText, required this.iconData, required this.iconColor, this.elevation = 6, this.shadowColor});

  final String infoText;
  final IconData iconData;
  final Color iconColor;
  final double elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      splashRadius: 0,
      surfaceTintColor: Colors.transparent,
      padding: const EdgeInsets.all(0),
      elevation: elevation,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(

                padding: const EdgeInsets.all(
                  16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  boxShadow: shadowColor != null ? [BoxShadow(color: shadowColor!)] : null,
                  // color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infoText,
                      // style: infoTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      onSelected: (value) {},
      position: PopupMenuPosition.over,
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
