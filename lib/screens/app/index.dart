/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expense_tracker/widgets/widgets.dart';
import 'package:expense_tracker/screens/app/app.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:expense_tracker/services/services.dart';

class AppIndexScreen extends StatefulWidget {

  const AppIndexScreen({super.key});

  @override
  State<AppIndexScreen> createState() => _AppIndexScreenState();

}

class _AppIndexScreenState extends State<AppIndexScreen> {
  int selectedScreen = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ExpenseAppService expenseService = ExpenseAppService();

  List<Widget> get _buildBody => <Widget>[
    DashboardScreen(transactions: recentTransactions),
    StatisticScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedScreen = index;
    });
  }


  List<dynamic> itemListApi = <dynamic>[];
  String? varsity;
  double grandTotal = 0.0;

  double currentMonth = 0.0;
  double lastMonth = 0.0;
  double? monthlyChange;
  List<Map<String, dynamic>> recentTransactions = <Map<String, dynamic>>[];


  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/data/expense_categories.json');
    final dynamic data = json.decode(response);
    setState(() {
      itemListApi = data;
    });
  }

  /*
  void _clearAll() async {
    await expenseService.truncateExpenses();
  }

  void _deleteTable() async {
    await expenseService.dropExpensesTable();
  }
  */

  Future<void> _getDbTotal() async {
    final List<Map<String, dynamic>> result = await expenseService.getAllExpensesFromDB();

    final double total = result.fold<double>(
      0.0,
          (double sum, Map<String, dynamic> e) => sum + (e['cost'] as num).toDouble(),
    );

    setState(() {
      grandTotal = total;
    });
  }

  void _clearTextField() {
    _nameController.clear();
    _costController.clear();
    _dateController.clear();
  }

  Future<void> _loadRecentTransactions() async {
    final List<Map<String, dynamic>> recent = await expenseService.getLast20Expenses();

    setState(() {
      recentTransactions = recent;
    });
  }

  String _getCategoryName(String? categoryId) {
    final dynamic category = itemListApi.firstWhere(
          (e) => e['id'] == categoryId,
      orElse: () => <String, String>{'description': 'Unknown'},
    );
    return category['description'];
  }

  void _saveExpense(Map<String, dynamic> data) async {
    await expenseService.insertExpense(
      name: data['name'],
      date: data['date'],
      categoryId: data['category'],
      cost: double.tryParse(data['cost']) ?? 0.0,
      categoryName: _getCategoryName(data['category']),
    );

    _clearTextField();
    await _getDbTotal(); // Update grand total
    await _loadRecentTransactions(); // Update transaction list
  }


  @override
  void initState() {
    super.initState();
    loadJson();
    //_clearAll();
    //_deleteTable();
    _getDbTotal();
    _loadRecentTransactions();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _costController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLimitReached = grandTotal > 100000;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody[selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedScreen,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF549994),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/svg/home_icon.svg'),
            activeIcon: SvgPicture.asset('assets/images/svg/home_icon.svg',
              colorFilter: const ColorFilter.mode(Color(0xFF549994), BlendMode.srcIn),
            ),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/svg/bar-chart_icon.svg'),
            activeIcon: SvgPicture.asset('assets/images/svg/bar-chart_icon.svg',
              colorFilter: const ColorFilter.mode(Color(0xFF549994), BlendMode.srcIn),
            ),
            label: 'Stats',
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/svg/wallet_icon.svg'),
            activeIcon: SvgPicture.asset('assets/images/svg/wallet_icon.svg',
              colorFilter: const ColorFilter.mode(Color(0xFF549994), BlendMode.srcIn),
            ),
            label: 'Wallet',
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/svg/user_icon.svg'),
            activeIcon: SvgPicture.asset('assets/images/svg/user_icon.svg',
              colorFilter: const ColorFilter.mode(Color(0xFF549994), BlendMode.srcIn),
            ),
            label: 'profile',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {

            if (isLimitReached) {
              _showMyDialog();
              return;
            }

            final result = await showModalBottomSheet(
                isDismissible: false,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return ExpenseBottomSheet(
                    formKey: _formKey,
                    itemNameController: _nameController,
                    itemCostController: _costController,
                    itemDateController: _dateController,
                    itemListApi: itemListApi,
                    varsity: varsity,
                    onCategoryChanged: (String? val) {
                      setState(() => varsity = val);
                    },
                  );
                }
            );
            if (result != null) {
              _saveExpense(result);
            }
          },
          elevation: 0, highlightElevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(64),
            ),
            child: Center(child: Icon(Icons.add, color: Colors.white)),
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eish Ja! neh...'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Looks like you need a premium account.'),
                SizedBox(height: 10),
                Text('Askies neh! Contact aceMedia'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}