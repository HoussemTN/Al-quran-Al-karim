import 'package:flutter/material.dart';
import 'package:quran/PDFBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Entity/Surah.dart';

class SurahListBuilder extends StatelessWidget {
  final List<Surah> surah;

  SurahListBuilder({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 55,
      addAutomaticKeepAlives: false,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(surah[index].titleAr),
        subtitle: Text(surah[index].title),
          leading: Image(
              image: AssetImage("assets/images/${surah[index].place}.png"),
              width: 30,
              height: 30),
          trailing: Text("${surah[index].pageIndex}"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PDFBuilder(pages:surah[index].pages)));
        }

      ),

      itemCount: surah.length,
    );
  }
}
