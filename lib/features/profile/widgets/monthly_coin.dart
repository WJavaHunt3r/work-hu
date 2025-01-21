import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif/gif.dart';

class MonthlyCoins extends StatefulWidget {
  final List<num> roundPoints;

  const MonthlyCoins({super.key, required this.roundPoints});

  @override
  State<MonthlyCoins> createState() => _MonthlyCoinsState();
}

class _MonthlyCoinsState extends State<MonthlyCoins> with TickerProviderStateMixin {
  late final GifController _controller;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        children: [
          coin(month: "Aug", points: widget.roundPoints[0]),
          coin(month: "Szept", points: widget.roundPoints[1]),
          coin(month: "Okt", points: widget.roundPoints[2]),
          coin(month: "Nov", points: widget.roundPoints[3]),
          coin(month: "Dec", points: widget.roundPoints[4])
        ],
      ),
    );
  }

  Widget coin({required String month, required num points}) {
    return Expanded(
        child: SizedBox(
      height: 110.sp,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              month,
              overflow: TextOverflow.ellipsis,
            ),
            points == 0
                ? const Image(
                    image: AssetImage(
                      "assets/img/PACE_Coin_Blank_Static.png",
                    ),
                    fit: BoxFit.fitWidth)
                : Gif(
                    controller: _controller,
                    autostart: Autostart.loop,
                    onFetchCompleted: () {
                      // _controller.reset();
                      _controller.forward();
                    },
                    image: AssetImage("assets/img/${"PACE_Coin_Buk_${points}_Spin_540px.gif"}"),
                    fit: BoxFit.fitWidth),
          ],
        ),
      ),
    ));
  }
}
