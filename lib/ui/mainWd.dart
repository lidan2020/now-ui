import 'package:Project_News/inc/init.dart';
import 'package:Project_News/ui/pagesUI/GpsPages.dart';
import 'package:Project_News/ui/pagesUI/HomePages.dart';
import 'package:Project_News/ui/pagesUI/UserPages.dart';
import 'package:flutter/material.dart';

class MainWd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainWd();
  }
}

class _MainWd extends State<MainWd> {
  int _currentIndex = 0;
  // 子页面设置
  List _listPageData = [HomePages(), UserPages(), GpsPages()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: this._listPageData[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(236, 93, 47, 1.0),
        currentIndex: this._currentIndex, //子页面 选中
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        iconSize: 36.0, //按钮大小
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), title: Text("人员查询")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin), title: Text("GPS")),
        ],
      ),
    );
  }
}
