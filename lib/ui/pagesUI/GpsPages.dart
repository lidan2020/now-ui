import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

class GpsPages extends StatefulWidget {
  @override
  _GpsPages createState() => _GpsPages();
}

class _GpsPages extends State<GpsPages> {
  @override
  Widget build(BuildContext context) {
    //宽
    final double PageWidth = window.physicalSize.width;
    return Center(
      child: Column(
        children: [
          Container(),
          Expanded(
            child: Container(
              color: Colors.amber,
              width: PageWidth,
              child: Text("GpsPages"),
            ),
          ),
        ],
      ),
    );
  }
}
