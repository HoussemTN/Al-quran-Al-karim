import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:quran/library/Globals.dart' as globals;
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/Bookmark.dart';
import '../Index.dart';

class SurahViewBuilder extends StatefulWidget {
  SurahViewBuilder({Key key, @required this.pages}) : super(key: key);
  final int pages;

  @override
  _SurahViewBuilderState createState() => _SurahViewBuilderState();
}

class _SurahViewBuilderState extends State<SurahViewBuilder> {
  /// My Document
  PDFDocument _document;

  /// On Double Tap Zoom Scale
  static const List<double> _doubleTapScales = <double>[1.0, 1.1];

  /// Current Page init (on page changed)
  int currentPage;

  /// Init Page Controller
  PageController pageController;

  bool isBookmarked = false;
  Widget _bookmarkWidget = Container();

  /// Used for Bottom Navigation
  int _selectedIndex = 0;

  /// Declare SharedPreferences
  SharedPreferences prefs;

  /// Load PDF Documents
  Future<PDFDocument> _getDocument() async {
    if (_document != null) {
      return _document;
    }

    /// Check Compatibility's [Android 5.0+]
    if (await hasSupport()) {
      _document = await PDFDocument.openAsset('assets/pdf/quran.pdf');
      return _document;
    } else {
      throw Exception(
        'المعذرة لا يمكن طباعة المحتوى'
            'يرجي التحقق من أن جهازك يدعم نظام أندرويد بنسخته 5 على الأقل',
      );
    }
  }

  /// Navigation event handler
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    /// Go to Bookmarked page
    if (index == 0) {
      setState(() {
        /// in case Bookmarked page is null (Bookmarked page initialized in splash screen)
        if (globals.bookmarkedPage == null) {
          globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
        }
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.bookmarkedPage - 1)),
              (Route<dynamic> route) => false);

      //Bookmark this page
    } else if (index == 1) {
      setState(() {
        globals.bookmarkedPage = globals.currentPage;
        print("toSave: ${globals.bookmarkedPage}");
      });
      if (globals.bookmarkedPage != null) {
        setBookmark(globals.bookmarkedPage);
      }

      //got to index
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Index()));
    }
  }

  PageController _pageControllerBuilder() {
    return new PageController(
        initialPage: widget.pages, viewportFraction: 1.1, keepPage: true);
  }

  /// set bookmarkPage in sharedPreferences
  void setBookmark(int _page) async {
    prefs = await SharedPreferences.getInstance();
    if (_page != null && !_page.isNaN) {
      await prefs.setInt(globals.BOOKMARKED_PAGE, _page);
    }
  }

  /// set lastViewedPage in sharedPreferences
  void setLastViewedPage(int _currentPage) async {
    prefs = await SharedPreferences.getInstance();
    if (_currentPage != null && !_currentPage.isNaN) {
      prefs.setInt(globals.LAST_VIEWED_PAGE, _currentPage);
      globals.lastViewedPage = prefs.getInt(globals.LAST_VIEWED_PAGE);
    }
  }

  closePage(page) async {
    await page.close();
  }

  @override
  void initState() {
    /// Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    setState(() {
      /// init current page
      globals.currentPage = widget.pages;
      pageController = _pageControllerBuilder();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageController = _pageControllerBuilder();
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

                  /// Update lastViewedPage
                  setLastViewedPage(currentPage);

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

                  Widget image = Stack(
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
                            cacheGesture: false,
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
                      isBookmarked == true ? _bookmarkWidget : Container(),
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
                onPageChanged: (page) {},
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'المعذرة لا يمكن طباعة المحتوى'
                    'يرجي التحقق من أن جهازك يدعم نظام أندرويد بنسخته 5 على الأقل',
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
        selectedFontSize: 12,
        onTap: (index) => _onItemTapped(index),
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