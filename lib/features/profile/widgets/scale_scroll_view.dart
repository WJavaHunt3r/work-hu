import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FreeScrollList extends StatefulWidget {
  final List<Widget> elements;

  const FreeScrollList({super.key, required this.elements});

  @override
  _FreeScrollListState createState() => _FreeScrollListState();
}

class _FreeScrollListState extends State<FreeScrollList> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const double itemWidth = 150.0; // Fixed width of your items

    return SizedBox(
        height: 50,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse, // This enables mouse-dragging
          }),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.elements.length,
            itemBuilder: (context, index) {
              // Calculate center of the item relative to the scroll view
              double itemCenter = (index * itemWidth) + (itemWidth / 2);
              double viewCenter = _scrollOffset + (MediaQuery.of(context).size.width / 2);

              // Calculate distance from center to determine scale
              double distance = (itemCenter - viewCenter).abs();
              double scale = (1.2 - (distance / 500)).clamp(0.7, 1.2);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    // color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: widget.elements[index],
                ),
              );
            },
          ),
        ));
  }
}
