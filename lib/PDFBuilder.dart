import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:quran/globals.dart' as globals;
import 'Bookmark.dart';

class PDFBuilder extends StatefulWidget {
  @override
  _PDFBuilderState createState() => _PDFBuilderState();
}

class _PDFBuilderState extends State<PDFBuilder> {
  PDFDocument _document;
  static const List<double> _doubleTapScales = <double>[1.0, 1.1];
  int currentPage = globals.currentPage;
  final pageController= new PageController(
    initialPage: globals.currentPage);
  bool isBookmarked = false;
  Widget _bookmarkWidget = Container();
  //Bottom Navigation
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Future<PDFDocument> _getDocument() async {
    if (_document != null) {
      return _document;
    }
    if (await hasSupport()) {
      return _document = await PDFDocument.openAsset('assets/quran.pdf');
    } else {
      throw Exception(
        'PDF Rendering does not '
        'support on the system of this version',
      );
    }
  }

  // navigation event handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index==0){
      pageController.animateToPage(globals.bookmarkedPage-1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }else if (index==1){
setState(() {
  globals.bookmarkedPage=globals.currentPage;
  print(globals.bookmarkedPage);
});


    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PDFDocument>(
        future: _getDocument(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  PDFView.builder(
                    scrollDirection: Axis.horizontal,
                    document: snapshot.data,
                    controller: pageController,

                    builder: (PDFPageImage pageImage, bool isCurrentIndex) {
                      if (pageImage.pageNumber.round().toInt() ==
                          globals.bookmarkedPage) {
                        isBookmarked = true;
                        _bookmarkWidget = Bookmark();
                      } else {
                        isBookmarked = false;
                        _bookmarkWidget = Container();
                      }

                      print("current:$currentPage");

                      Widget image = Stack(
                        children: <Widget>[
                          ExtendedImage.memory(
                            pageImage.bytes,
                            fit: BoxFit.fitWidth,
                            // gesture not applied (minScale,maxScale,speed...)
                            mode: ExtendedImageMode.gesture,
                            initGestureConfigHandler: (_) => GestureConfig(
                              //minScale: 1,
                              // animationMinScale:1,
                              // maxScale: 1.1,
                              //animationMaxScale: 1,
                              speed: 1,
                              inertialSpeed: 100,
                              inPageView: true,
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
                          _bookmarkWidget,
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
                      currentPage = page.round().toInt();
                      globals.currentPage = currentPage;
                      if (currentPage == globals.bookmarkedPage) {
                        isBookmarked = true;
                      } else {
                        isBookmarked = false;
                      }
                      print("$isBookmarked:$currentPage");
                    },
                  ),
                  //_bookmarkWidget,
                ],
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
        onTap: _onItemTapped,
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
