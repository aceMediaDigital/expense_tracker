/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticScreen extends StatefulWidget {

  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  bool showAvg = false;

  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: <Widget>[
            SizedBox(height: 60),
            Text('Statistics', style: TextStyle(fontSize: 18, color: Color(0XFF222222), fontWeight: FontWeight.w700)),

            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0XFF438883),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Day', style: TextStyle(fontSize: 13, color: Colors.white))),
                ),
      
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Week', style: TextStyle(fontSize: 13, color: Color(0xFF666666))))
                ),
      
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('Month', style: TextStyle(fontSize: 13, color: Color(0xFF666666))))
                ),
      
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('Year', style: TextStyle(fontSize: 13, color: Color(0xFF666666))))
                ),
              ],
            ),
            SizedBox(height: 26),
      
            Stack(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1.70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 12,),
                        child: LineChart(
                          mainData(),
                        ),
                      )
                  ),
                ]
            ),
            SizedBox(height: 30),
      
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Top Spend Category', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Icon(Icons.swap_vert,color: Color(0XFF666666))
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: 14,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0XFF29756F),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Food', style: TextStyle(color: Colors.black, fontSize: 16)),
                              ],
                            ),
                            Spacer(),
                            Text('R 1 370.65', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF25A969)),),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16,);

    Widget text;

    switch (value.toInt()) {
      case 2:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('June', style: style);
        break;
      case 8:
        text = const Text('July', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }


  ///////
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (double value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (double value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d),width: 3),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: const <FlSpot>[
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false,),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

}
