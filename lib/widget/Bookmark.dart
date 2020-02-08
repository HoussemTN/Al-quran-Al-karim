import 'package:flutter/material.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        child: Align(
          alignment: Alignment.topLeft,
          child: Opacity(
            opacity: 0.8,
            child: Icon(
              Icons.bookmark,
              color: Colors.red[800],
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
