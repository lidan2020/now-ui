import 'package:Project_News/inc/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePages extends StatefulWidget {
  @override
  _HomePages createState() => _HomePages();
}

//93, 173, 226
final Color listColor = Colors.black45;

class _HomePages extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    //宽
    final double PageWidth = window.physicalSize.width - 220;
    return Container(
      decoration: new BoxDecoration(color: Color.fromRGBO(236, 93, 47, 1.0)),
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0), //外边距
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle, // 默认值也是矩形
                  borderRadius: new BorderRadius.circular((10.0)), // 圆角度
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                        blurRadius: 15.0, //阴影模糊程度
                        spreadRadius: 5.0 //阴影扩散程度
                        )
                  ]),
              //padding: EdgeInsets.fromLTRB(0.00, 6.00, 0.00, 6.00),
              width: PageWidth,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(20.0), //外边距
                    //color: Colors.red,
                    width: PageWidth / 2,
                    height: 300,
                    child: Column(
                      children: [
                        Container(
                          //内间距
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.topLeft,
                          // child: Text("36.01℃"),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            // textDirection:,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              new Text(
                                "平均体温",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 15.0,
                                ),
                              ),
                              new Text(
                                "36.02℃",
                                // textAlign: TextAlign.right,
                                style: new TextStyle(
                                  color: Color.fromRGBO(255, 99, 7, 1.0), //字体颜色
                                  fontFamily: "Montserrat",
                                  fontSize: 42.0,
                                ),
                              ),
                            ],
                          ),
                          // color: Colors.green,
                          width: PageWidth / 2,
                          height: 100,
                        ),
                        // Container(
                        //   child: Text("text2"),
                        //   color: Colors.black,
                        // ),
                        Container(
                          //内间距
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Image.asset('', width: 22, height: 22),
                              Text(' 正常工作：5',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(' 无信号：5',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(' 体温异常：0',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10.0), //外边距
                      //color: Colors.red,
                      //height: 300,
                      child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 13.0,
                          animation: true,
                          animationDuration: 1000, //动画时长

                          percent: 0.8, //设置比例

                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //自定义
                              new Text(
                                "正常",
                                // textAlign: TextAlign.right,
                                style: new TextStyle(
                                  color: Colors.blue, //字体颜色
                                  fontFamily: "Montserrat",
                                  fontSize: 42.0,
                                ),
                              ),
                            ],
                          ),
                          // 236, 93, 47, 0.2 //异常
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Color.fromRGBO(50, 205, 50, 0.2),
                          linearGradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(50, 205, 50, 0.1),
                              Color.fromRGBO(50, 205, 50, 1)
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              // 这里设置子控件
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2.0), //外边距
                decoration: BoxDecoration(
                    color: listColor,
                    shape: BoxShape.rectangle, // 默认值也是矩形
                    borderRadius: new BorderRadius.circular((10.0)), // 圆角度
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                          blurRadius: 15.0, //阴影模糊程度
                          spreadRadius: 1.0 //阴影扩散程度
                          )
                    ]),
                width: PageWidth,
                height: screenSize(window).height - statusBarHeight(context),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                    _getChannelsPercents(
                        channel: "名字",
                        percent: 30.00,
                        percentString: "38",
                        pTime: "12:00"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==============================
_getChannelsPercents(
    {String channel = "Unkown",
    double percent = 0,
    String percentString,
    String pTime}) {
  return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      //color: listColor,
      child: Column(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 警员照片
              ClipOval(
                child: Image.asset(
                  imagesUserPath + "1.jpg",
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              // 警员姓名
              Text("姓名：" + channel,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.0)),
              // 测温时间
              Text(pTime,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.0)),
              // 体温
              Text(percentString + '℃',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.0))
            ]),
        Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: Stack(children: <Widget>[
              Container(height: 1.0, color: Colors.black),
              // Container(
              //     width: screenSize(window).width * percent,
              //     height: 1.0,
              //     color: Colors.black)
            ]))
      ]));
}
//==============================

//==============================
//static List<charts.Series<LinearSales, int>>
_createSampleData() {
  final data = [
    new GaugeSegment('Low', 100),
    new GaugeSegment('Acceptable', 75),
  ];

  return [
    new charts.Series<GaugeSegment, String>(
      id: 'Segments',
      domainFn: (GaugeSegment segment, _) => segment.segment,
      measureFn: (GaugeSegment segment, _) => segment.size,
      data: data,
    )
  ];
}

/// Sample linear data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

//===============================
