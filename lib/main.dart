/* =======================================================
 *
 * Created by anele on 25/06/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:expense_tracker/screens/screens.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DeviceConfig().init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((dynamic value) => runApp( const ExpenseTrackerApp() ));
}

class ExpenseTrackerApp extends StatelessWidget {

  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Inter',
      ),
      home: const IntroScreen(),
    );
  }
}
