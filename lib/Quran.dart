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

  int currentPage=569 ;
 Widget _bookmarkWidget= Container();
  @override
  void initState() {
    super.initState();

  }
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          PDFBuilder(),


        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('الإنتقال إلى العلامة'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            title: Text('حفظ العلامة'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_rtl),
            title: Text('الفهرس'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
      ),
    );

  }

}
