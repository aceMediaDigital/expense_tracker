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
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/services/services.dart';

class StatisticScreen extends StatefulWidget {

  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int touchedIndex = 0;

  final ExpenseAppService expenseService = ExpenseAppService();
  List<Map<String, dynamic>> allTimeCategories = <Map<String, dynamic>>[];
  final List<Color> sectionColors = <Color>[
    Colors.lightBlue, Colors.deepPurpleAccent,
    Colors.purple, Colors.blueGrey
  ];

  bool isIphoneSeDevice = DeviceConfig().isIphoneSE;


  Future<void> _loadWalletExpenses() async {
    final Map<String, dynamic> result = await expenseService.getCategoriesByTotal();
    setState(() {
      allTimeCategories = result['categories'];
      //allTimeCategories = [];
    });
  }


  @override
  void initState() {
    super.initState();
    _loadWalletExpenses();
  }


  @override
  Widget build(BuildContext context) {

    Size screen = MediaQuery.of(context).size;

    if (allTimeCategories.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 26, color: Colors.black),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: <Widget>[
            SizedBox(height: isIphoneSeDevice ? 30 : 60),
            Text('Statistics', style: TextStyle(fontSize: 18, color: Color(0XFF222222), fontWeight: FontWeight.w700)),

            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

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
                        //color: Color(0XFF438883),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('Month', style: TextStyle(fontSize: 13 )))
                ),

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('Year', style: TextStyle(fontSize: 13,)))
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0XFF438883),
                      //color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text('All Time', style: TextStyle(fontSize: 13, color: Colors.white))),
                ),
              ],
            ),
            SizedBox(height: 76),


            SizedBox(
              height: 220, width: screen.width,
              child: PieChart(
                PieChartData(
                  sections: List.generate(
                      allTimeCategories.length > 4 ?
                      4 : allTimeCategories.length,
                        (index) {
                        final Map<String, dynamic> item = allTimeCategories[index];
                        return PieChartSectionData(
                          radius: touchedIndex == index ? 60 : 50,
                          color: sectionColors[index],
                          //title: item['categoryName'],
                          value: item['total'] as double,
                          titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w800),
                      );
                    },
                  ),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                      if (response != null && response.touchedSection != null) {
                        setState(() {
                          touchedIndex = response.touchedSection!.touchedSectionIndex;
                        });
                      }
                    },
                  ),
                  centerSpaceRadius: 100,
                  centerSpaceColor: Colors.black12,
                ),
              ),
            ),
            SizedBox(height: 50),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                allTimeCategories.length > 4 ? 4 : allTimeCategories.length,
                    (index) {
                  final item = allTimeCategories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Indicator(
                      color: sectionColors[index % sectionColors.length],
                      text: item['categoryName'],
                      isSquare: true,
                    ),
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }

}
