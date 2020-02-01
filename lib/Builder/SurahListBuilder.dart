import 'package:flutter/material.dart';
import 'package:quran/Builder/PDFBuilder.dart';
import '../Entity/Surah.dart';

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
    if(surah.isNotEmpty){
      surah.clear();
    }
    surah.addAll(widget.surah);
  }

  void filterSearchResults(String query) {
    /// Fill surah list if empty
    initSurahListView();
    /// SearchList contains every surah
    List<Surah> searchList = List<Surah>();
    searchList.addAll(surah);
    /// Contains matching surah(s)
    List<Surah> listData = List<Surah>();
    if (query.isNotEmpty) {
      /// Loop all surah(s)
      searchList.forEach((item) {
        /// Filter by (titleAr:exact,title:partial,pageIndex)
        if (item.titleAr.contains(query) ||
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex.toString().contains(query)) {
          listData.add(item);
        }
      });
      /// Fill surah List with searched surah(s)
      setState(() {
        surah.clear();
        surah.addAll(listData);
      });
      return;
      /// Show all surah list
    } else {
      setState(() {
        surah.clear();
        surah.addAll(widget.surah);
      });
    }
  }

  @override
  void initState() {
    /// Init listView with all surah(s)
    initSurahListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          /// Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.green,
              onChanged: (value) {
                  filterSearchResults(value);
                  print(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "البحث عن سورة",
                  // hintText: "البحث",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))
              ),
            ),
          ),
          /// ListView represent all/searched surah(s)
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
                    /// Push to Quran view ([int pages] represent surah page(reversed index))
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
