import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran/Bookmark.dart';
import 'package:quran/PDFBuilder.dart';
import 'package:quran/globals.dart' as globals;
class Quran extends StatefulWidget {
  @override
  _QuranState createState() => _QuranState();

}

class _QuranState extends State<Quran> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PDFBuilder();

  }

}
