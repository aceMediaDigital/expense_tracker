/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expense_tracker/screens/app/app.dart';
import 'package:expense_tracker/services/services.dart';

class AppIndexScreen extends StatefulWidget {

  const AppIndexScreen({super.key});

  @override
  State<AppIndexScreen> createState() => _AppIndexScreenState();

}

class _AppIndexScreenState extends State<AppIndexScreen> {
  int selectedScreen = 0;

  final ExpenseAppService expenseService = ExpenseAppService();

  List<Widget> get _buildBody => <Widget>[
    DashboardScreen(),
    StatisticScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedScreen = index;
    });
  }


  void _clearAll() async {
    await expenseService.truncateExpenses();
  }

  void _deleteTable() async {
    await expenseService.dropExpensesTable();
  }

  @override
  void initState() {
    super.initState();
    //_clearAll();
    //_deleteTable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
    );
  }


}