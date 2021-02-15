import 'dart:async';

import 'package:Project_News/common/httpResponse.dart';
import 'package:Project_News/dao/userDao.dart';
import 'package:Project_News/database/app_database.dart';
import 'package:Project_News/inc/init.dart';
import 'package:Project_News/model/HomeUI.dart';
import 'package:Project_News/model/user.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Project_News/db/BaseDBProvider.dart';

class HomePages extends StatefulWidget {
  // DB用户对象
  HomeUI _homeUI = HomeUI("00.0", "0", "0", "0");
  final database = $FloorAppDatabase.databaseBuilder().build();

  @override
  _HomePages createState() => _HomePages();
}

//93, 173, 226
final Color listColor = Colors.black45;

class _HomePages extends State<HomePages> {
  // DB通信计时器
  Timer tDBTimer;
  // 界面刷新计时器
  Timer UITimer;
  int counter = 0;
  List<User> _userList = List();

  @override
  Future<void> initState() {
    super.initState();
    //_getUserOnBoard();
    loggedIn = true;
    // DB 逻辑初期化
    // DB 存在判断 不存在创建

    // 网络温度通信
    tDBTimer = Timer.periodic(Duration(seconds: 10), (Timer t) => addValue());
  }

  //创建 用户列表
  // 界面刷新计时器
  //UITimer = Timer.periodic(Duration(seconds: 15), (Timer t) => UIShow());
  // 添加人员
  // createDataBase().then((myDb) {
  //   int i = 1;
  //   UserList.forEach((_sn) {
  //     User _user =
  //         User(i, "0000" + i.toString(), "姓名", _sn, "", "0.0", "00:00");

  //     String code = _user.code;
  //     String name = _user.name;
  //     String sn = _user.sn;
  //     String image = _user.image;

  //     String add_sql =
  //         "INSERT INTO user(id,code,name,sn,image,wd,time) VALUES('$i','$code','$name','$sn','$image','0.0','00:00')";
  //     myDb.transaction((tran) async {
  //       await tran.rawInsert(add_sql);
  //     }).catchError((e) {
  //       print(e);
  //     });

  //     i++;
  //   });
  // });

  // 得到人员列表
  Future<List<User>> getUserPage() async {
    //List<User> userGroup = new List();
    // await DBManager().queryUserAllList().then((onValue) {
    //   userGroup = onValue;
    // });

    final database = $FloorAppDatabase.databaseBuilder().build();
    await database.then((onValu) {
      onValu.userDao.findAllUser().then((onValue) {
        if (onValue != null) {
          _userList.clear();
          _userList.addAll(onValue);
          _userList.sort((left, right) => left.time.compareTo(right.wd));
        }
      });
    }).catchError((e) {
      print(e);
    });

    return _userList;
  }

  int rowID = 0;
  // 网络通信写数据库
  void addValue() async {
    print("网络通信写数据库 开始");

    // 服务器通信，手环数据读取
    getUserList(rowID);
    rowID++;
    if (rowID > 15) {
      rowID = 0;
    }
    print("网络通信写数据库 结束 " + rowID.toString());

    getUserPage().then((userList) {
      if (userList != null) {
        _userList.clear();
        _userList.addAll(userList);
      }
    });
    print("界面刷新================================");
    print("界面刷新");
    // 体温信息取得
    double lDouble = 0;
    int i = 0;
    int iError = 0;

    _userList.forEach((user) {
      if (double.parse(user.wd) > 0) {
        lDouble = lDouble + double.parse(user.wd);
        if (double.parse(user.wd) > 38) {
          iError++;
        }
        i++;
      }
    });

    lDouble = lDouble / i;

    // 计算总人数
    widget._homeUI.snNum = _userList.length.toString();
    // 计算平均温度 sql 计算
    widget._homeUI.wd = lDouble.toString();

    // 异常体温
    widget._homeUI.errorWd = iError.toString();
    print("界面刷新================================");

    setState(() {});
  }

  // 界面刷新
  void UIShow() {
    //uiWd = DBManager().getWDCount().toString();
    setState(() {
      getUserPage().then((userList) {
        if (userList != null) {
          _userList.addAll(userList);
          print("界面刷新================================");
          print("界面刷新");
          // 体温信息取得
          double lDouble = 0;
          int i = 0;
          int iError = 0;

          _userList.forEach((user) {
            if (double.parse(user.wd) > 0) {
              lDouble = lDouble + double.parse(user.wd);
              if (double.parse(user.wd) > 38) {
                iError++;
              }
              i++;
            }
          });

          lDouble = lDouble / i;

          // 计算总人数
          widget._homeUI.snNum = _userList.length.toString();
          // 计算平均温度 sql 计算
          widget._homeUI.wd = lDouble.toString();
          // 异常体温
          widget._homeUI.errorWd = iError.toString();
          print("界面刷新================================");
        }
      });
    });
  }

  // 计算平均温度
  String setWd() {
    double lDouble = 0;
    int i = 0;
    int iError = 0;

    _userList.forEach((user) {
      if (double.parse(user.wd) > 0) {
        lDouble = lDouble + double.parse(user.wd);
        if (double.parse(user.wd) > 38) {
          iError++;
        }
        i++;
      }
    });

    lDouble = lDouble / i;

    // 计算总人数
    widget._homeUI.snNum = _userList.length.toString();
    // 计算平均温度 sql 计算
    widget._homeUI.wd = lDouble.toString();
    // 异常体温
    widget._homeUI.errorWd = iError.toString();
  }

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
                                widget._homeUI.wd + "℃",
                                //getWDCount(),
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
                              Text(' 正常工作：' + widget._homeUI.snNum,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(' 无信号：',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(' 体温异常：' + widget._homeUI.errorWd,
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
                                //"正常" + counter.toString(),
                                "正常" + rowID.toString(),
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
                height:
                    screenSize(window).height - statusBarHeight(context) - 50,
                child: FutureBuilder<List<User>>(
                    future: getUserPage(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      // 请求已结束
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // 请求失败，显示错误
                          return Text("Error: ${snapshot.error}");
                        } else {
                          // 请求成功，显示数据
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  //child: ListTile(),
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(20.0),
                                    children: <Widget>[
                                      _getChannelsPercents(
                                          channel: snapshot.data[index].code,
                                          percent: 30.00,
                                          percentString:
                                              snapshot.data[index].wd,
                                          pTime: snapshot.data[index].time),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        // 请求未结束，显示loading
                        return CircularProgressIndicator();
                      }
                    }),

                // ListView(
                //   shrinkWrap: true,
                //   padding: const EdgeInsets.all(20.0),
                //   children: userGroup,),
                // <Widget>[
                //   _getChannelsPercents(
                //       channel: "名字",
                //       percent: 30.00,
                //       percentString: "38",
                //       pTime: "12:00"),
                // ]
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                // _getChannelsPercents(
                //     channel: "名字",
                //     percent: 30.00,
                //     percentString: "38",
                //     pTime: "12:00"),
                //),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //==============================

  Widget _getChannelsPercents(
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
                        letterSpacing: 1.0)),
                // 编辑按钮
                IconButton(
                  icon: Icon(Icons.edit),
                  iconSize: 50,
                  onPressed: () {
                    //处理逻辑
                  },
                  color: Colors.red,
                  disabledColor: Colors.black,
                  splashColor: Colors.yellow,
                  highlightColor: Colors.green,
                ),
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
}

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
