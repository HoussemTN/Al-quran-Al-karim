import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:screen/screen.dart';

class SliderAlert extends StatefulWidget {
  @override
  _SliderAlertState createState() => _SliderAlertState();
}

class _SliderAlertState extends State<SliderAlert> {
  double brightness=0.5 ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
          title: Text("إضاءة الشاشة",textDirection: TextDirection.rtl),
          content: Container(
            height: 24,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.highlight,
                  size: 24,
                ),
                Slider(
                  value: brightness,
                  onChanged: (_brightness){
                    setState(() {
                      brightness=_brightness;
                    });
                    Screen.setBrightness(_brightness);
                  },
                  max: 1,
                  label: "$brightness",
                  divisions: 5,),
              ],
            ),
          ),
        actions: <Widget>[
          FlatButton(
            child: Text("إلغاء",textDirection: TextDirection.rtl,),
            onPressed: null,),
          FlatButton(
            child: Text("حفظ",textDirection: TextDirection.rtl,),
            onPressed: null,),

        ],
      ),
    );
  }
}
