import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:screen/screen.dart';
import 'package:quran/library/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliderAlert extends StatefulWidget {
  @override
  _SliderAlertState createState() => _SliderAlertState();
}

class _SliderAlertState extends State<SliderAlert> {
  /// Declare sharedPreferences
  SharedPreferences prefs;

  /// Temp Brightness Level (not save it yet)
  double tempBrightnessLevel;

  setBrightnessLevel(double level) async {
    globals.brightnessLevel = level;
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(globals.BRIGHTNESS_LEVEL, globals.brightnessLevel);
  }

  @override
  void initState() {
    if (globals.brightnessLevel != null) {
      setState(() {
        tempBrightnessLevel = globals.brightnessLevel;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("إضاءة الشاشة", textDirection: TextDirection.rtl),
        content: Container(
          height: 24,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.highlight,
                size: 24,
              ),
              Slider(
                value: tempBrightnessLevel,
                onChanged: (_brightness) {
                  setState(() {
                    tempBrightnessLevel = _brightness;
                  });
                  Screen.setBrightness(tempBrightnessLevel);
                },
                max: 1,
                label: "$tempBrightnessLevel",
                divisions: 10,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                "إلغاء",
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          FlatButton(
            child: Text(
              "حفظ",
              textDirection: TextDirection.rtl,
            ),
            onPressed: () {
              setBrightnessLevel(tempBrightnessLevel);
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: " تم الحفظ بنجاح",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 18.0);
            },
          ),
        ],
      ),
    );
  }
}
