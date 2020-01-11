import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';


void main() => runApp(Quran());

class Quran extends StatefulWidget {
  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  PDFDocument _document;
  static const List<double> _doubleTapScales = <double>[1.0, 2.0];
  int currentPage;
  final pageController = PageController(
    initialPage: 569,
      viewportFraction: 1,
      keepPage: true
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(primaryColor: Colors.white),
    home: Scaffold(
     // appBar: AppBar(title: Text('PDFView example')),
      body: FutureBuilder<PDFDocument>(
        future: _getDocument(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                PDFView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.horizontal,
                  document: snapshot.data,
                  controller: pageController,
                  builder: (PDFPageImage pageImage, bool isCurrentIndex) {
                    Widget image = ExtendedImage.memory(
                      pageImage.bytes,
                      fit: BoxFit.fitWidth,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (_) => GestureConfig(
                        minScale: 1,
                        animationMinScale: .75,
                        maxScale: 2,
                        animationMaxScale: 2.5,
                        speed: 1,
                        inertialSpeed: 100,
                        inPageView: true,
                        initialScale: 1.2,
                        cacheGesture: false,
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

                    );
                    if (isCurrentIndex) {
                      image = Hero(
                        tag: 'pdf_view' + pageImage.pageNumber.toString(),
                        child: image,
                      );
                    }

                    return image;
                  },

                ),
                /* Align(
                      alignment: Alignment.center,
                      child: Text(
                        '$_actualPageNumber/${snapshot.data.pagesCount}',
                        style: TextStyle(fontSize: 34),
                      ),
                    )*/
              ],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'PDF Rendering does not '
                    'support on the system of this version',
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    ),
  );


  Future<bool> hasSupport() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool hasSupport = androidInfo.version.sdkInt >= 21;
    return hasSupport;
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
}
