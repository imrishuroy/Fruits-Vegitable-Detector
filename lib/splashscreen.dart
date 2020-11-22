import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'homescreen.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomeScreen(),
      title: Text(
        'Fluits&Vegitable Detector',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
      image: Image.asset('assets/fruit.png'),
      photoSize: 50.0,
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.004, 1],
        colors: [
          Color(0xff00b4db),
          Color(0xff0083b0),
        ],
      ),
      loaderColor: Colors.white,
    );
  }
}

// 952347
