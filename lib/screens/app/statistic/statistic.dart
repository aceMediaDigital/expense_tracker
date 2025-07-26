/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {

  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Statistic Screen', style: TextStyle(fontSize: 22)),
      )
    );
  }
}
