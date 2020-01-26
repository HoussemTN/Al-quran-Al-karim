import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  createState() => _SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            () => Navigator.pushReplacementNamed(context, "index"));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 144,
              height: 144,
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          Center(
            child: Container(
              child: Text(
                "بِسْم اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
