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
  List<Surah> surah = List<Surah>();

  void initSurahListView() {
    surah.addAll(widget.surah);
  }

  void filterSearchResults(String query) {
    List<Surah> dummySearchList = List<Surah>();
    dummySearchList.addAll(surah);
    if (query.isNotEmpty) {
      List<Surah> dummyListData = List<Surah>();
      dummySearchList.forEach((item) {
        //filter by (titleAr:exact,title:partial,pageIndex)
        if (item.titleAr.contains(query) ||
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex == int.tryParse(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        surah.clear();
        surah.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        surah.clear();
        surah.addAll(widget.surah);
      });
    }
  }

  @override
  void initState() {
    initSurahListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "البحث عن سورة",
                  // hintText: "البحث",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: surah.length,
              itemExtent: 80,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(surah[index].titleAr),
                  subtitle: Text(surah[index].title),
                  leading: Image(
                      image:
                          AssetImage("assets/images/${surah[index].place}.png"),
                      width: 30,
                      height: 30),
                  trailing: Text("${surah[index].pageIndex}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PDFBuilder(pages: surah[index].pages)));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
