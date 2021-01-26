import 'dart:ui';
import 'package:flutter/material.dart';
import '../inc/init.dart';
import 'story/story.dart' show Story;
import 'package:charts_flutter/flutter.dart' as charts;

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  final double newsSpansSize = 11.0;
  final double sourceIconSize = 12.0;
  final double timeIconSize = 16.0;

  Widget _getBookmarksStories(
      {String title,
      String source,
      String datetime,
      String section,
      Function onTap}) {
    return ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.all(20.0),
        title: Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4))),
        subtitle: //Source, DateTime
            Container(
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          //Source
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(children: <Widget>[
                Image.asset(imagesPath + "source.png",
                    width: sourceIconSize, color: Colors.grey[800]),
                Text("  $source",
                    style:
                        TextStyle(color: Colors.black, fontSize: newsSpansSize))
              ])),
          //DateTime
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Image.asset(imagesPath + "time.png",
                width: timeIconSize, color: Colors.grey[800]),
            Text("  $datetime",
                style: TextStyle(color: Colors.black, fontSize: newsSpansSize))
          ]),
          //Section
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () => print(section.toUpperCase() + " Clicked!"),
                      child: Container(
                          // alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(140, 140, 140, 1),
                                      width: 1.0))),
                          child: Text(section.toUpperCase(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: newsSpansSize,
                                  color: Colors.black))))))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Drawer
        drawerScrimColor: Colors.transparent,
        drawer: getDrawer(context),
        //App Bar
        appBar: AppBar(
            elevation: .0,
            leading: Builder(
                builder: (context) => Tooltip(
                    message: "Open navigation menu",
                    child: GestureDetector(
                        child: Image.asset(imagesPath + "menu.png",
                            semanticLabel: "Aside (navigation) menu",
                            scale: appBarIconScale),
                        onTap: () =>
                            Scaffold.of(context).openDrawer()))), //Menu
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
            backgroundColor: appMainColor),
        body: Container(
            child: Column(children: <Widget>[
          //温度曲线图
          Container(
            width: screenSize(window).width,
            height: 300.0,
            color: appSecColor,
            child: new charts.LineChart(_getSeriesData(), animate: true),
            //new charts.LineChart(_getSeriesData(), animate: true),
            //new charts.PieChart(_createSampleData(), animate: true),
          ),
          Container(
            width: screenSize(window).width,
            height: 300.0,
            color: appSecColor,
            child: new charts.PieChart(_createSampleData(),
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.outside)
                    ])),
          ),
          //信息提示
          Expanded(
              child: ListView(children: <Widget>[
            //======================================================================
            _getBookmarksStories(
                title: "姓名：XXX 体温超标请注意！",
                source: "39℃",
                datetime: "2021年1月20日",
                section: "处理状态",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Story(1)))),
            //===================================================================
          ]))
        ])));
  }
}

_getSeriesData() {
  List<charts.Series<SalesData, int>> series = [
    charts.Series(
        //dot color is fillcolorfn
        fillColorFn: (SalesData series, _) =>
            charts.MaterialPalette.green.shadeDefault,
        //seriesColor: charts.ColorUtil.fromDartColor(Colors.red),

        id: "Sales",
        data: data,
        patternColorFn: (SalesData series, _) => charts.MaterialPalette.white,
        // areaColorFn: ((SalesData series, _) => charts.MaterialPalette.black),
        // domainUpperBoundFn: (SalesData series, _) => series.domainUpper,
        // domainLowerBoundFn: (SalesData series, _) => series.domainLower,
        // measureUpperBoundFn: (SalesData series, _) => series.measureUpper,
        // measureLowerBoundFn: (SalesData series, _) => series.measureLower,
        domainFn: (SalesData series, _) => series.year,
        measureFn: (SalesData series, _) => series.sales,
        colorFn: (SalesData series, _) =>
            charts.MaterialPalette.red.shadeDefault),
  ];

  return series;
}

final data = [
  new SalesData(1, 36),
  new SalesData(2, 36),
  new SalesData(3, 37),
  new SalesData(4, 35),
  new SalesData(5, 39),
  new SalesData(6, 35),
  new SalesData(7, 38),
  new SalesData(8, 36),
  new SalesData(9, 36),
  new SalesData(10, 36),
  new SalesData(11, 36),
  new SalesData(12, 36)
];

class SalesData {
  final int year;
  final int sales;

  SalesData(this.year, this.sales);
}

//==============================
//static List<charts.Series<LinearSales, int>>
_createSampleData() {
  final data = [
    new LinearSales("体温正常", 10),
    new LinearSales("异常", 1),
    new LinearSales("值班", 25),
    new LinearSales("外勤", 5),
  ];

  return [
    new charts.Series<LinearSales, String>(
      id: 'Sales',
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
    )
  ];
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}
