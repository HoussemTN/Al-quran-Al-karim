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
  int currentPage = 569;
  bool isBookmarked = false;

 Widget _bookmarkWidget =Container();


  @override
  void initState() {
    isBookmarked?  Align(
      alignment: Alignment.topLeft,
      child: Opacity(
        opacity: 0.8,
        child: Icon(
          Icons.bookmark,
          color: Colors.red[800],
          size: 40.0,
        ),
      ),
    ):Container();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder<PDFDocument>(
        future: _getDocument(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  PDFView.builder(
                    scrollDirection: Axis.horizontal,
                    document: snapshot.data,
                    controller: new PageController(initialPage: 569),
                    builder: (PDFPageImage pageImage, bool isCurrentIndex) {
                        if(pageImage.pageNumber.round().toInt()==globals.bookmarkedPage){
                          isBookmarked=true;
                      _bookmarkWidget =Bookmark();
                        }else{
                          isBookmarked=false;
                          _bookmarkWidget=Container() ;
                        }
                           
                        print("current:$currentPage");

                        Widget image =Stack(
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
                              final pointerDownPosition = state.pointerDownPosition;
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
                      if(currentPage==globals.bookmarkedPage){
                        isBookmarked=true;
                      }else {
                        isBookmarked = false;
                      }
                      print("$isBookmarked:$currentPage");

                    },

                  ),
                    _bookmarkWidget,
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
    );
  }

  Future<bool> hasSupport() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool hasSupport = androidInfo.version.sdkInt >= 21;
    return hasSupport;
  }

  void showBookmark(int position) {
    print("global: ${globals.currentPage}");
    if (position == globals.bookmarkedPage) {
      setState(() {
        _bookmarkWidget =  Align(
          alignment: Alignment.topLeft,
          child: Opacity(
            opacity: 0.8,
            child: Icon(
              Icons.bookmark,
              color: Colors.red[800],
              size: 40.0,
            ),
          ),
        );
      });
    } else {
      setState(() {
        _bookmarkWidget = new Container();
      });
    }
  }
}
