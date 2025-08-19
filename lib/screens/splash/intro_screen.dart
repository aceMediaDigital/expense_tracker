/* =======================================================
 *
 * Created by anele on 29/06/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:moola_mate/utils/utils.dart';
import 'package:moola_mate/screens/app/index.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  bool isIphoneSeDevice = DeviceConfig().isIphoneSE;
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              'Moola Mate',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                                'Because you wanna keep your bucks in check',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)
                            ),
                          ),
                        ],
                      )
                  ),
                ),

                // Screen Two
                Column(
                  children: <Widget>[
                    Container(
                      height: screen.height * 0.7, width: screen.width,
                      decoration: BoxDecoration(
                        //image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/background.png')),
                      ),
                      child: Lottie.asset(
                          'assets/images/icons/LottieAnim.json'),
                    ),

                    SizedBox(
                      width: screen.width, height: screen.height * 0.3,
                      child: Column(
                        children: <Widget>[
                          //SizedBox(height: 20),
                          Text(
                              textAlign: TextAlign.center,
                              'Monitor Your Spend\nSave a Buck',
                              style: TextStyle(color: Color(0xFF438883), fontSize: isIphoneSeDevice ? 26 : 36, fontWeight: FontWeight.bold)
                          ),

                          Spacer(),

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
                                  boxShadow: isIphoneSeDevice
                                      ? <BoxShadow>[]
                                      : const <BoxShadow>[
                                        BoxShadow(
                                          offset: Offset(0, 5),
                                          color: Color(0xFF3E7C78),
                                          spreadRadius: 1, blurRadius: 10,
                                        ),
                                  ],
                              ),
                              height: isIphoneSeDevice ? 47 : 67, width: screen.width * 0.7,
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
