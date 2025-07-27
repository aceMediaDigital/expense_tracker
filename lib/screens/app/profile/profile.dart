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
    Size screen = MediaQuery.of(context).size;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // Curved Header
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                      clipper: BottomCurveClipper(),
                      child: Container(
                          height: screen.height * 0.35, width: screen.width,
                          decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[Color(0xFF429690), Color(0xFF2A7C76)]
                          )
                        ),
                          child: Center(child: Text('🇿🇦', style: TextStyle(fontSize: 80)))
                      )
                  )
                ),


                // Avatar overlapping
                Positioned(
                bottom: -20, left: 0, right: 0,
                child: CircleAvatar(
                  radius: 50, backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: AssetImage('assets/images/anele.jpeg'),
                  ),
                ),
              ),
            ]
        ),
        SizedBox(height: 40),

        Center(
          child: Column(
            children: <Widget>[
              Text('Ace Media', style: TextStyle(fontSize: 20, color: Color(0XFF222222))),
              Text('hello@acemedia.co.za', style: TextStyle(fontSize: 14, color: Color(0XFF438883))),
            ],
          ),
        ),

        SizedBox(height: 40),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Icon(Icons.person),
                title: Text('Account info', style: TextStyle(fontSize: 16,color: Color(0XFF000000)),),
                trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              ),

              ListTile(
                dense: true,
                leading: Icon(Icons.group),
                title: Text('Personal profile', style: TextStyle(fontSize: 16,color: Color(0XFF000000)),),
                trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              ),

              ListTile(
                dense: true,
                leading: Icon(Icons.mail),
                title: Text('Message center', style: TextStyle(fontSize: 16,color: Color(0XFF000000)),),
                trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              ),

              ListTile(
                dense: true,
                leading: Icon(Icons.security),
                title: Text('Login and security', style: TextStyle(fontSize: 16,color: Color(0XFF000000)),),
                trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              ),

              ListTile(
                dense: true,
                leading: Icon(Icons.lock_clock),
                title: Text('Data and privacy', style: TextStyle(fontSize: 16,color: Color(0XFF000000)),),
                trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
              ),
            ],
          ),
        )
      ]
    );
  }
}


class BottomCurveClipper extends CustomClipper<Path> {
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