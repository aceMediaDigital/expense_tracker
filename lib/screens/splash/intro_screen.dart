/* =======================================================
 *
 * Created by anele on 29/06/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  final PageController _controller = PageController();

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
                          colors: <Color>[
                            Color(0xFF63B5AF),
                            Color(0xFF438883),
                          ]
                      )
                  ),
                  child: Center(child: Text('mono', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w800))),
                ),

                // ScreenTwo
                Container(),
              ]
          ),

          AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: currentPage == 0 ? 0.0 : 1.0,
            child: Container(
              alignment: Alignment(0,  -0.80),
              child: SmoothPageIndicator(
                count: 6, controller: _controller,
                effect: const WormEffect(dotColor: Colors.red, activeDotColor: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
