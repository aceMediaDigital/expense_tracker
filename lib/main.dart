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
import 'package:expense_tracker/services/services.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DeviceConfig().init();

  final LocalNotificationService notificationService = LocalNotificationService();

  await notificationService.initNotification();
  await notificationService.scheduleEveningReminders();

  await notificationService.requestPermissions();

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
