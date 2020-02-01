import 'package:flutter/material.dart';
import 'package:quran/PDFBuilder.dart';
import 'Entity/Surah.dart';
class SurahListBuilder extends StatefulWidget {
  final List<Surah> surah;
  SurahListBuilder({Key key, this.surah}) : super(key: key);
  @override
  _SurahListBuilderState createState() => _SurahListBuilderState();
}

class _SurahListBuilderState extends State<SurahListBuilder> {

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.surah.length,
      itemExtent: 80,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(widget.surah[index].titleAr),
        subtitle: Text(widget.surah[index].title),
          leading: Image(
              image: AssetImage("assets/images/${widget.surah[index].place}.png"),
              width: 30,
              height: 30),
          trailing: Text("${widget.surah[index].pageIndex}"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PDFBuilder(pages:widget.surah[index].pages)));
        }

      ),


    );
  }
}
