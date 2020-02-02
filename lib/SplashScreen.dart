import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran/library/Globals.dart' as globals;
import 'package:screen/screen.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Declare SharedPreferences
  SharedPreferences prefs;

  /// Get saved Brightness or the default value if Brightness level is not defined
  getBrightnessLevel()async{
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.BRIGHTNESS_LEVEL)) {
      var _brightnessLevel = prefs.getDouble(globals.BRIGHTNESS_LEVEL);
      setState(() {
        globals.brightnessLevel = _brightnessLevel;
      });
    }else{
      globals.brightnessLevel=globals.DEFAULT_BRIGHTNESS_LEVEL;
    }
  }

  /// get bookmarkPage from sharedPreferences
  getBookmark() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.BOOKMARKED_PAGE)) {
      var bookmarkedPage = prefs.getInt(globals.BOOKMARKED_PAGE);
      setState(() {
        globals.bookmarkedPage = bookmarkedPage;
      });

      /// if not found return default value
    } else {
      globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
    }
  }

  @override
  void initState() {
    /// get Saved preferences
    getBookmark();
    getBrightnessLevel();
     Timer(Duration(seconds: 3),
              () => Navigator.pushReplacementNamed(context, "index"));
    super.initState();
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
