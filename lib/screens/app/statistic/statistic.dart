/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticScreen extends StatefulWidget {

  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  bool showAvg = false;
  DateTime now = DateTime.now();

  List<Color> gradientColors = <Color>[
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  @override
  Widget build(BuildContext context) {

    Size screen = MediaQuery.of(context).size;

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
                    //color: Color(0XFF438883),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('Day', style: TextStyle(fontSize: 13,))),
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
                        //color: Colors.transparent,
                        color: Color(0XFF438883),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('Month', style: TextStyle(fontSize: 13, color: Colors.white )))
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
      

            SizedBox(
              height: 220, width: screen.width,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false, border: Border.all(width: .2)),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      gradient: LinearGradient(colors: <Color>[
                        Colors.lightBlue, Colors.purple, Colors.red
                      ]),
                      barWidth: 8,
                      isCurved: true,
                      isStrokeCapRound: true,
                      //preventCurveOverShooting: true,
                      spots: <FlSpot>[
                        FlSpot(0, 0),
                        FlSpot(1, 3),
                        FlSpot(2, 0),
                      ]
                    ),

                    LineChartBarData(
                        barWidth: 8,
                        isCurved: true,
                        color: Colors.green,
                        isStrokeCapRound: true,
                        spots: <FlSpot>[
                          FlSpot(0, 0.9),
                          FlSpot(1, 0.3),
                          FlSpot(2, 1),
                        ]
                    ),

                    LineChartBarData(
                        barWidth: 8,
                        isCurved: true,
                        color: Colors.brown,
                        isStrokeCapRound: true,
                        spots: <FlSpot>[
                          FlSpot(0, 1.3),
                          FlSpot(1, 2.3),
                          FlSpot(2, 1.3),
                        ]
                    ),

                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        interval: 1,
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final List<String> months = List.generate(3, (int i) {
                            final DateTime date = DateTime(now.year, now.month - (3 - i));
                            return DateFormat('MMM').format(date);
                          });

                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(months[value.toInt()], style: TextStyle(fontSize: 12));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  )
                ),
              ),
            ),
            SizedBox(height: 30),

            /*
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
            ),
            */
          ]
        ),
      ),
    );
  }

}
