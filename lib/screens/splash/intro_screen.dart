/* =======================================================
 *
 * Created by anele on 29/06/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/app/index.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  final PageController _controller = PageController();


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (_controller.hasClients) {
        _controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
              controller: _controller,
              onPageChanged: (int index) {
                setState(() {});
              },
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color(0xFF63B5AF), Color(0xFF438883)]
                      )
                  ),
                  child: Center(
                      child: Text(
                          'mono',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w800)
                      )
                  ),
                ),

                // Screen Two
                Column(
                  children: <Widget>[
                    Container(
                      height: screen.height * 0.7, width: screen.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/background.png'),
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              top: 120, left: 48,
                              child: Image.asset('assets/images/coin.png')
                          ),

                          Positioned(
                            right: 30, top: screen.height * 0.2,
                              child: Image.asset('assets/images/donut.png')
                          ),
                          Positioned(
                            top: 120,
                            child: Image.asset(
                              //width: screen.width, height: 300,
                              'assets/images/moneyman.png',
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: screen.width, height: screen.height * 0.3,
                      child: Column(
                        children: <Widget>[
                          Text(
                              textAlign: TextAlign.center,
                              'Spend Smarter\nSave More',
                              style: TextStyle(color: Color(0xFF438883), fontSize: 36, fontWeight: FontWeight.bold)
                          ),
                          SizedBox(height: 20),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AppIndexScreen()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[Color(0xFF63B5AF), Color(0xFF438883)]
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    offset: Offset(0, 10),
                                    color: Color(0XFF3E7C78),
                                    spreadRadius: 3, blurRadius: 24,
                                  )
                                ],
                              ),
                              height: 67, width: screen.width * 0.7,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'Get Started',
                                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Already have account? Log In',
                            style: TextStyle(fontSize: 14, color: Color(0xFF444444),),
                          ),
                          Spacer()
                        ],
                      ),
                    )
                  ],
                ),
              ]
          ),
        ],
      ),
    );
  }
}
