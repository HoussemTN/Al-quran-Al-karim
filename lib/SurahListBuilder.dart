import 'package:flutter/material.dart';

import 'Entity/Surah.dart';

class SurahListBuilder extends StatelessWidget {
  final List<Surah> surah;

  SurahListBuilder({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => ListTile(
        leading: Icon(Icons.format_list_numbered),
        title: Text(surah[index].titleAr),
        subtitle: Text(surah[index].title),
        trailing: Image(
            image: AssetImage("assets/images/${surah[index].place}.png"),
            width: 30,
            height: 30),
        onTap: () {},
      ),
      itemCount: surah.length,
    );
  }
}
