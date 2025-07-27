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

class AppIndexScreen extends StatefulWidget {

  const AppIndexScreen({super.key});

  @override
  State<AppIndexScreen> createState() => _AppIndexScreenState();

}

class _AppIndexScreenState extends State<AppIndexScreen> {
  int selectedScreen = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedScreen = index;
    });
  }

  final List<Widget> _buildBody = const <Widget> [
    DashboardScreen(),
    StatisticScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

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
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
}