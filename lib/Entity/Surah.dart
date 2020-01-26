class Surah {
  String place;
  String type;
  int count;
  String title;
  String titleAr;
  String index;
  String pages;
  String juzIndex;

  Surah(
      {this.place,
      this.type,
      this.count,
      this.title,
      this.titleAr,
      this.index,
      this.pages,
      this.juzIndex});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return new Surah(
      place: json['place'] as String,
      type: json['type'] as String,
      count: json['count'] as int,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      index: json['index'] as String,
      pages: json['pages'] as String,
      juzIndex: json['juzIndex'] as String,
    );
  }
}
