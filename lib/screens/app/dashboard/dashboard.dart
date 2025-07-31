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
import 'package:expense_tracker/services/services.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  double currentMonth = 0.0;
  double lastMonth = 0.0;
  double? monthlyChange;
  List<Map<String, dynamic>> recentTransactions = <Map<String, dynamic>>[];

  final DateTime now = DateTime.now();

  String getPreviousMonthName() {
    final DateTime previous = DateTime(now.year, now.month - 1, 1);
    return DateFormat.yMMMM().format(previous);
  }

  final ExpenseAppService expenseService = ExpenseAppService();

  Future<void> _loadExpenses() async {
    final List<Map<String, dynamic>> last20Expense = await expenseService.getLast20Expenses();
    final List<Map<String, dynamic>> lastMonthExpenses = await expenseService.getPreviousMonthExpenses();
    final List<Map<String, dynamic>> currentMonthExpenses = await expenseService.getCurrentMonthExpenses();

    final double currentMonthTotal = currentMonthExpenses.fold<double>(
      0.0, (double sum, Map<String, dynamic> item) => sum + (item['cost'] as double));

    final double lastMonthTotal = lastMonthExpenses.fold<double>(
      0.0, (double sum, Map<String, dynamic> item) => sum + (item['cost'] as double));

    final double change = expenseService.calculateMonthlyChangePercentage(
      currentMonthTotal: currentMonthTotal,
      lastMonthTotal: lastMonthTotal,
    );

    setState(() {
      currentMonth = currentMonthTotal;
      lastMonth = lastMonthTotal;
      monthlyChange = change;
      recentTransactions = last20Expense;
    });
  }

  String getGreeting() {
    final int hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return SingleChildScrollView(
      //physics: ,
      child: Column(
        children: <Widget>[
          Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // Curved Header
                Align(
                    alignment: Alignment.topCenter,
                    child: ClipPath(
                        clipper: DashboardCurveClipper(),
                        child: Container(
                            height: 287, width: screen.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[Color(0xFF429690), Color(0xFF2A7C76)]
                                )
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 80),
                                    Text(getGreeting(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                    Text('Anele', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                                  ],
                                ),
                              ],
                            )
                        )
                    )
                ),


                // Card overlapping
                Positioned(
                  top: 150,
                  left: (screen.width - (screen.width * 0.9)) / 2,
                  child: Container(
                      width: screen.width * 0.9, height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      decoration: BoxDecoration(
                        color: Color(0XFF2F7E79),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                textAlign: TextAlign.center,
                                '${DateFormat.yMMMM().format(now)} Total - (so far)',
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              Icon(Icons.more_horiz, color: Colors.white,)
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('R ${currentMonth.toStringAsFixed(2) ?? '0.00'}', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      //Icon(Icons.do_not_disturb, size: 20, color: Colors.white),
                                      //SizedBox(width: 5),
                                      Text('${getPreviousMonthName()} Total', style: TextStyle(fontSize: 16, color: Color(0XFFD0E5E4)),)
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text('R ${lastMonth.toStringAsFixed(2) ?? '0.00'}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 24, height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Center(child: Icon(
                                            lastMonth > currentMonth
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward, size: 20, color: Colors.white)),
                                      ),
                                      SizedBox(width: 5),
                                      Text('% Diff', style: TextStyle(fontSize: 16, color: Color(0XFFD0E5E4)),)
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(' ${monthlyChange?.toStringAsFixed(2)}%', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              ]
          ),

          //
          SizedBox(height: 100),

          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Transactions history', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('See all', style: TextStyle(fontSize: 14, color: Colors.grey),)
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  child: recentTransactions == null
                      ? Center(child: CircularProgressIndicator())
                      : recentTransactions.isEmpty
                      ? Center(child: Text('No transactions yet', style: TextStyle(color: Colors.grey, fontSize: 16)))
                      : ListView.builder(
                    itemCount: recentTransactions.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> expense = recentTransactions[index];

                      final DateTime parsedDate = DateTime.parse(expense['date']);

                      String displayDate;
                      final DateTime today = DateTime(now.year, now.month, now.day);
                      final DateTime yesterday = today.subtract(Duration(days: 1));
                      final DateTime expenseDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

                      if (expenseDay == today) {
                        displayDate = 'Today';
                      } else if (expenseDay == yesterday) {
                        displayDate = 'Yesterday';
                      } else {
                        displayDate = DateFormat('dd MMM yyyy').format(parsedDate);
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 50, height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0XFFF0F6F5),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(expense['name'], style: TextStyle(color: Colors.black, fontSize: 16)),
                                    Text(displayDate, style: TextStyle(color: Color(0XFF666666), fontSize: 13)),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Text('R ${(expense['cost'] as num).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF25A969)),),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DashboardCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    // Create the curve
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
