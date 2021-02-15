import 'dart:async';
import 'dart:ui';
import 'package:Project_News/common/httpResponse.dart';
import 'package:Project_News/model/temperatureData.dart';
import 'package:flutter/material.dart';
import '../inc/init.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  GlobalKey<_OverviewState> textKey = GlobalKey();

  Widget _getChannelsPercents(
      {String channel = "Unkown",
      double percent = 0,
      String percentString,
      String pTime}) {
    return Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 警员照片
                Image.asset(imagesUserPath + "1.jpg",
                    width: 40.0, fit: BoxFit.fill),
                // 警员姓名
                Text("姓名：" + channel,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0)),
                // 测温时间
                Text(pTime,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0)),
                // 体温
                Text(percentString + '℃',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0))
              ]),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Stack(children: <Widget>[
                Container(height: 1.0, color: Colors.white24),
                Container(
                    //TODO: Add BoxShadow to this Container with appropriate color from web
                    width: screenSize(window).width * percent,
                    height: 1.0,
                    color: Colors.white)
              ]))
        ]));
  }

  @override
  void initState() {
    super.initState();

    // 访问服务器体温数据
    //_userList = getUserList();
    _getTemperatureList = fetchTemperatureList("");

    ///循环执行
    //_timer = Timer.periodic(Duration(seconds: 60), (Timer t) => addValue());
    // ///间隔1秒
    // _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
    //   ///自增
    //   curentTimer++;

    //   ///到5秒后停止
    //   if (curentTimer == 5) {
    //     // _timer.cancel();
    //     curentTimer = 0;
    //     // 访问服务器体温数据
    //     _getTemperatureList = fetchTemperatureData();
    //     // 执行刷新
    //     //_globalKey.currentState.onPressed();

    //   }
    // });
  }

  @override
  void dispose() {
    // 取消定时访问温度数据
    _timer.cancel();
    super.dispose();
  }

  //================================================
  // 温度显示 方法实现
  Future<GetTemperatureData> _getTemperatureList;
  List<Temperature> _userList;

  //温度定时访问
  Timer _timer;

  ///当前的时间
  int curentTimer = 0;

  GlobalKey _globalKey = GlobalKey(); // 1. GlobalKey生成

  // 警员温度显示
  // userData     : 警员名称信息
  // temperature  : 警员体温
  // pTime        : 测温时间
  List<Widget> _userListView(List<Temperature> temperatureDataList) {
    return temperatureDataList
        .map((f) => _getChannelsPercents(
            channel: f.sn,
            percent: double.parse(f.wd) <= 0 ? 0 : double.parse(f.wd),
            percentString: f.wd.toString(),
            pTime: f.pTime))
        .toList();
  }

  void addValue() {
    setState(() {
      // 访问服务器体温数据
      //_userList = getUserList();
      _getTemperatureList = fetchTemperatureList("689464703098034");

      //curentTimer++;
    });
  }
  //================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Drawer
        drawerScrimColor: Colors.transparent,
        drawer: getDrawer(context),
        //App Bar
        appBar: AppBar(
            leading: Builder(
              builder: (context) => Tooltip(
                message: "Open navigation menu",
                child: GestureDetector(
                    child: Image.asset(imagesPath + "menu.png",
                        semanticLabel: "App Logo", scale: appBarIconScale),
                    onTap: () => Scaffold.of(context).openDrawer()),
              ),
            ), //Menu
            title: Image.asset(imagesPath + "logo.png",
                scale: appBarIconScale), //Logo
            centerTitle: true,
            actions: <Widget>[
              Tooltip(
                  message: "Search",
                  child: GestureDetector(
                      onTap: () {},
                      child: Container(
                          child: Image.asset(imagesPath + "search.png",
                              scale: appBarIconScale))))
            ],
            elevation: .0,
            backgroundColor: appMainColor),
        body: SingleChildScrollView(
            //There's padding in bottom, idk coming from where, maybe padding, DevTool inspector doesn't help
            child: Container(
                color: Color.fromRGBO(236, 93, 47, 1.0),
                width: screenSize(window).width,
                height: screenSize(window).height - statusBarHeight(context),
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Text("警员体温数据",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            letterSpacing: 1.0)),
                  ),
                  Text("体温监控，实时为你提供警员体温情况！",
                      style: TextStyle(color: Colors.white54, fontSize: 12.0)),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(25.0),
                          //Percents
                          //====体温显示==================================
                          child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                //==============================
                                // 回调函数 返回值赋值
                                RepaintBoundary(
                                  key: _globalKey,
                                  child: FutureBuilder<GetTemperatureData>(
                                    future: _getTemperatureList,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          //==============================
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: _userListView(
                                                  snapshot.data.data)
                                              // _getChannelsPercents(
                                              //     channel: "警员000002",
                                              //     percent: .34,
                                              //     percentString: "34"),
                                              );
                                          //==============================
                                        }
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),

                                  //==============================
                                )
                              ])
                          //===体温显示结束===========================
                          ))
                ])

                //===网络数据回显===================================
                )));
  }
}

class HttpResponse {}
