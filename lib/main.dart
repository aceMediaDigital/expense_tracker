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
import 'package:moola_mate/utils/utils.dart';
import 'package:moola_mate/screens/screens.dart';
import 'package:moola_mate/services/services.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DeviceConfig().init();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const ExpenseTrackerApp());

  // Runs after the first frame is drawn so the Android notification
  // permission prompt can't block the app from ever opening.
  final LocalNotificationService notificationService = LocalNotificationService();
  await notificationService.initNotification();
  await notificationService.scheduleEveningReminders();
  await notificationService.requestPermissions();
}

class ExpenseTrackerApp extends StatelessWidget {

  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moola Mate',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Inter',
      ),
      home: const IntroScreen(),
    );
  }
}
