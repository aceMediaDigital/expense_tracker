/* =======================================================
 *
 * Created by anele on 26/06/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */


import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {

  const AppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent
      ),
      child: Center(
        child: Text('Button'),
      ),
    );
  }
}
