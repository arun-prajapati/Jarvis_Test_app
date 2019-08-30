import 'package:flutter/material.dart';
import 'pages/splashScreen.dart';
import 'pages/home.dart';
import 'pages/test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'home':(context)=>Home(),
      },
    );
  }
}
