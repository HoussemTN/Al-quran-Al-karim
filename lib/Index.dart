import 'package:flutter/material.dart';
import 'dart:convert';
import 'Entity/Surah.dart';
import 'Builder/SurahListBuilder.dart';
class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading:IconButton(
            icon:Icon(Icons.book,
            color: Colors.white,
          ), onPressed: () {

          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('الفهرس')),
              Icon(
                Icons.format_list_numbered_rtl,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: Container(
          child: Directionality(
            textDirection: TextDirection.rtl,
            /// Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/surah.json'),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<Surah> surahList =
                    parseJson(snapshot.data.toString());
                    return surahList.isNotEmpty ?
                    new SurahListBuilder(surah: surahList)
                        : new Center(child: new CircularProgressIndicator());
                  }else{
                    return new Center(child: new CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),

    );
  }
  List<Surah> parseJson(String response) {
    if(response==null){
      return [];
    }
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Surah>((json) => new Surah.fromJson(json)).toList();
  }
}


