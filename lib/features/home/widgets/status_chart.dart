import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:work_hu/features/teams/data/model/team_model.dart';

class StatusChart extends StatelessWidget {
  const StatusChart({
    super.key,
    required this.teams,
  });

  final List<TeamModel> teams;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            textStyle: TextStyle(fontSize: 18.sp),
            toggleSeriesVisibility: false,
            legendItemBuilder: (String name, ChartSeries<dynamic, dynamic>? series, ChartPoint<dynamic> point, int index) {
              series as CircularSeries<TeamModel, String>;
              var data = series.dataSource!;
              return Row(
                children: [
                  Container(
                    height: 15.sp,
                    width: 15.sp,
                    color: Color(int.parse("0x${data[index].color ?? ""}")),
                  ),
                  Image(image: AssetImage(data[index].iconAssetPath ?? ""), fit: BoxFit.fitWidth, height: 50.sp),
                ],
              );
            }),
        series: <CircularSeries<TeamModel, String>>[
          PieSeries<TeamModel, String>(
              enableTooltip: true,
              explode: true,
              dataSource: teams,
              pointColorMapper: (team, index) => Color(int.parse("0x${team.color ?? ""}")),
              sortFieldValueMapper: (data, _) => data.teamName,
              xValueMapper: (TeamModel data, _) => data.teamName,
              yValueMapper: (TeamModel data, _) => num.parse(data.coins.toStringAsFixed(2)),
              dataLabelSettings: DataLabelSettings(
                  labelAlignment: ChartDataLabelAlignment.top,
                  labelPosition: ChartDataLabelPosition.inside,
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 20.sp, fontFamily: "Good-Timing"))),
        ],
        centerX: "50%",
        centerY: "50%");
  }
}
