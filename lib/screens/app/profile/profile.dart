/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 22)),
      )
    );
  }
}
