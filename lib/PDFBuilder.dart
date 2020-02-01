import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:quran/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/Bookmark.dart';
import 'Index.dart';

class PDFBuilder extends StatefulWidget {

  PDFBuilder({Key key, @required this.pages}) : super(key: key);
  final int pages ;
  @override
  _PDFBuilderState createState() => _PDFBuilderState();
}

class _PDFBuilderState extends State<PDFBuilder> {
  // My Document
  PDFDocument _document;
  // On Double Tap Zoom Scale
  static const List<double> _doubleTapScales = <double>[1.0, 1.1];
  // Current Page init (on page changed)
  int currentPage;
  // Init Page Controller
  PageController pageController ;
  bool isBookmarked = false;
  Widget _bookmarkWidget = Container();
  //Bottom Navigation
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  SharedPreferences prefs;
  Future<PDFDocument> _getDocument() async {
    if (_document != null) {
      return _document;
    }
    if (await hasSupport()) {
      prefs = await SharedPreferences.getInstance();
      getBookmark();
      return _document = await PDFDocument.openAsset('assets/pdf/quran.pdf');
    } else {
      throw Exception(
        'PDF Rendering does not '
            'support on the system of this version',
      );
    }
  }

  // navigation event handler
  _onItemTapped(int index ,PageController _pageController) {
    setState(() {
      _selectedIndex = index;
    });
    //Go to Bookmarked page
    if (index == 0) {
      setState(() {
        getBookmark();
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  PDFBuilder(pages:globals.bookmarkedPage-1)),(Route<dynamic> route) => false);

      //Bookmark this page
    } else if (index == 1) {
      setState(() {
        globals.bookmarkedPage = globals.currentPage;
        print("toSave${globals.bookmarkedPage}");
        setBookmark(globals.bookmarkedPage);
      });

      //got to index
    }else if (index == 2){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Index()));
    }
  }
  PageController _pageControllerBuilder(){
    return new PageController(initialPage: widget.pages,viewportFraction: 1.1, keepPage: true);
  }
  @override
  void initState() {
    setState(() {
      //init current page
      globals.currentPage=widget.pages;
      pageController= _pageControllerBuilder();
    });
    super.initState();
  }
  // set bookmarkPage in sharedPreferences
  void setBookmark(int page)async{
    await prefs.setInt('bookmarkedPage',page);
 }
  // get bookmarkPage from sharedPreferences
  getBookmark()async{
    if(prefs.containsKey('bookmarkedPage')){
    var bookmarkedPage = prefs.getInt('bookmarkedPage');
      setState(() {
        globals.bookmarkedPage=bookmarkedPage;
      });
      // if not found return default value
    }else{
      globals.bookmarkedPage=globals.defaultBookmarkedPage;
    }
 }
  @override
  Widget build(BuildContext context) {
    pageController= _pageControllerBuilder();
    return Scaffold(
      body: FutureBuilder<PDFDocument>(
        future: _getDocument(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: PDFView.builder(
                scrollDirection: Axis.horizontal,
                document: snapshot.data,
                controller: pageController,
                builder: (PDFPageImage pageImage, bool isCurrentIndex) {
                  currentPage = pageImage.pageNumber;
                  globals.currentPage = currentPage;
                  if (currentPage == globals.bookmarkedPage) {
                    isBookmarked = true;
                  } else {
                    isBookmarked = false;
                  }
                  print("$isBookmarked:$currentPage");
                  if (isBookmarked) {
                     _bookmarkWidget = Bookmark();
                  } else {
                      _bookmarkWidget = Container();
                  }


                  Widget image =   Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        child: ExtendedImage.memory(
                          pageImage.bytes,
                          // gesture not applied (minScale,maxScale,speed...)
                          mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (_) => GestureConfig(
                            //minScale: 1,
                            // animationMinScale:1,
                            // maxScale: 1.1,
                            //animationMaxScale: 1,
                            speed: 1,
                            inertialSpeed: 100,
                            //inPageView: true,
                            initialScale: 1,
                            cacheGesture: true,
                          ),
                          onDoubleTap: (ExtendedImageGestureState state) {
                            final pointerDownPosition =
                                state.pointerDownPosition;
                            final begin = state.gestureDetails.totalScale;
                            double end;
                            if (begin == _doubleTapScales[0]) {
                              end = _doubleTapScales[1];
                            } else {
                              end = _doubleTapScales[0];
                            }
                            state.handleDoubleTap(
                              scale: end,
                              doubleTapPosition: pointerDownPosition,
                            );
                          },
                        ),
                      ),
                      isBookmarked == true ? _bookmarkWidget:Container(),


                    ],
                  );
                  if (isCurrentIndex) {
                    //currentPage=pageImage.pageNumber.round().toInt();
                    image = Hero(
                      tag: pageImage.pageNumber.toString(),
                      child: Container(child: image),
                      transitionOnUserGestures: true,
                    );
                  }
                  return image;
                },
                onPageChanged: (page) {

                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'PDF Rendering does not '
                    'support on the system of this version',
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
        selectedItemColor: Colors.grey[600],
        onTap:(index) =>_onItemTapped(index,pageController),
      ),
    );
  }

  Future<bool> hasSupport() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool hasSupport = androidInfo.version.sdkInt >= 21;
    return hasSupport;
  }
}

