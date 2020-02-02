import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran/library/Globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Declare SharedPreferences
  SharedPreferences prefs;

  /// get bookmarkPage from sharedPreferences
  getLastViewedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.LAST_VIEWED_PAGE)) {
      var _lastViewedPage = prefs.getInt(globals.LAST_VIEWED_PAGE);
      setState(() {
        globals.lastViewedPage = _lastViewedPage;
      });
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
      globals.bookmarkedPage = globals.defaultBookmarkedPage;
    }
  }

  @override
  void initState() {
    getBookmark();
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
