import 'dart:io';

import 'package:Project_News/database/app_database.dart';
import 'package:Project_News/inc/init.dart';
import 'package:Project_News/model/user.dart';
import 'package:Project_News/db/BaseDBProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'dart:ui';

//List<CameraDescription> cameras;

class UserPages extends StatefulWidget {
  @override
  _UserPages createState() => _UserPages();
}

//93, 173, 226
final Color listColor = Color.fromRGBO(236, 93, 47, 1.0);

Size screenSize(window) {
  final _screenSize = MediaQueryData.fromWindow(window).size;
  return _screenSize;
}

double statusBarHeight(context) {
  final _statusBarHeight = MediaQuery.of(context).padding.top;
  return _statusBarHeight;
}

class _UserPages extends State<UserPages> {
  var _image;
  String _cameraScanResult = "请输入手环编码";
  final picker = ImagePicker();

  String code = "";
  String name = "";
  String shNo = "";

  //=====================================
  bool ckValue = false;
  // WdDao _wdDao;
  // List<Wd> wdList = [];
  List<bool> cbList = [];

  //  List<bool> sizeOfList = ;
  final database = $FloorAppDatabase.databaseBuilder().build();
  //=====================================
  //QRReaderController controller;
//=======================================
  // @override
  // void initState() {
  //   super.initState();

  //   getcameras();

  //   controller = new QRReaderController(
  //       cameras[0], ResolutionPreset.medium, [CodeFormat.qr], (dynamic value) {
  //     print(value); // the result!
  //     // ... do something
  //     // wait 3 seconds then start scanning again.
  //     new Future.delayed(const Duration(seconds: 3), controller.startScanning);
  //   });
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //     controller.startScanning();
  //   });
  // }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

  //===================================
  // Future getcameras() async {
  //   cameras = await availableCameras();
  // }

  Future getCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getPhoto() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //扫码函数,最简单的那种
  Future scan() async {
    // setState(() {
    //   if (cameraScanResult != null) {
    //     _cameraScanResult = cameraScanResult;
    //   }
    // });
  }

  //imagesUserPath + "1.jpg";

  @override
  Widget build(BuildContext context) {
    FocusNode usernameFocus;
    FocusNode passwordFocus;
    bool isFocusedUsername = false;
    bool isFocusedPassword = false;

    //宽
    final double PageWidth = window.physicalSize.width;
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

    // 提示窗体
    _showStateDialog(String _strText) {
      var _form = _formKey.currentState;
      if (_form.validate()) {
        _form.save();
        _saveCall();
        print(name);
        print(code);
        print(shNo);
        _strText = "添加警员数据: 警号：" + code + " - 姓名：" + name + " 编码：" + shNo;
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          // 通过 StatefulBuilder 来保存 dialog 状态
          // builder 需要传入一个 BuildContext 和 StateSetter 类型参数
          // StateSetter 有一个 VoidCallback，修改状态的方法在这写
          builder: (context) => StatefulBuilder(
              builder: (context, dialogStateState) => SimpleDialog(
                    title: Text('信息提示'),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    children: <Widget>[
                      Text(' $_strText', style: TextStyle(fontSize: 18.0)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              // RaisedButton(
                              //   // 通过 StatefulBuilder 的 StateSetter 来修改值
                              //   onPressed: () =>
                              //       dialogStateState(() => increase()),
                              //   child: Text('点我自增'),
                              // ),
                              // RaisedButton(
                              //   onPressed: () =>
                              //       dialogStateState(() => decrease()),
                              //   child: Text('点我自减'),
                              // ),
                              RaisedButton(
                                onPressed: () => Navigator.of(context).pop(1),
                                child: Text('确定'),
                              )
                            ]),
                      )
                    ],
                  )));
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                //color: Colors.amber,
                margin: const EdgeInsets.all(10.0),
                width: PageWidth,
                child: Container(
                  margin: const EdgeInsets.all(2.0), //外边距
                  decoration: BoxDecoration(
                      color: listColor,
                      shape: BoxShape.rectangle, // 默认值也是矩形
                      borderRadius: new BorderRadius.circular((10.0)), // 圆角度
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
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
                        //添加控件
                        //添加头像
                        Container(
                          width: screenSize(window).width,
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.topLeft,
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                //Submit Button
                                Center(
                                  child: _image == null
                                      ? ClipOval(
                                          child: Image.asset(
                                            imagesUserPath + "1.jpg",
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipOval(
                                          child: Image.file(_image, height: 100)
                                          //Image.file(_image),
                                          ),
                                ),
                                Center(
                                  child: Row(children: <Widget>[
                                    FloatingActionButton(
                                      onPressed: getCamera,
                                      tooltip: 'Pick Image',
                                      child: Icon(Icons.add_a_photo),
                                    ),
                                    Text("  "),
                                    FloatingActionButton(
                                      onPressed: getPhoto,
                                      tooltip: 'Pick Image',
                                      child: Icon(Icons.add_photo_alternate),
                                    ),
                                  ]),
                                ),
                              ]),
                        ),
                        //添加警号
                        Container(
                          margin: EdgeInsets.fromLTRB(25.0, .0, 25.0, 15.0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, .2),
                              borderRadius: BorderRadius.circular(35.0)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: usernameFocus,
                            //onEditingComplete: () => _focusPassword(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: isFocusedUsername ? '' : "请输入警号",
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              contentPadding: EdgeInsets.all(20.0),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 5.0),
                                child: Image.asset(imagesPath + "calendar.png",
                                    scale: 1.8,
                                    semanticLabel:
                                        "Username Text Field, Icon (User)"),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              //RegExp reg = new RegExp(r'^\d{6}$');

                              if (value.length > 6) {
                                return '请输入6位警号';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              code = value;
                            },
                          ),
                        ),
                        //添加姓名
                        Container(
                          margin: EdgeInsets.fromLTRB(25.0, .0, 25.0, 15.0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, .2),
                              borderRadius: BorderRadius.circular(35.0)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: usernameFocus,
                            //onEditingComplete: () => _focusPassword(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: isFocusedUsername ? '' : "请输入姓名",
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              contentPadding: EdgeInsets.all(20.0),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 5.0),
                                child: Image.asset(imagesPath + "profile.png",
                                    scale: 1.8,
                                    semanticLabel:
                                        "Username Text Field, Icon (User)"),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              //RegExp reg = new RegExp(r'^\d{10}$');
                              if (value.length > 20) {
                                return '姓名不能大于10个汉字';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name = value;
                            },
                          ),
                        ),
                        //添加手环编码
                        Container(
                          margin: EdgeInsets.fromLTRB(25.0, .0, 25.0, 15.0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, .2),
                              borderRadius: BorderRadius.circular(35.0)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: usernameFocus,
                            //onEditingComplete: () => _focusPassword(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  isFocusedUsername ? '' : _cameraScanResult,
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              contentPadding: EdgeInsets.all(20.0),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Image.asset(imagesPath + "search.png",
                                    scale: 1.8,
                                    semanticLabel:
                                        "Username Text Field, Icon (User)"),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              //RegExp reg = new RegExp(r'^\d{10}$');
                              if (value.length > 10) {
                                return '手环编码不能大于10个汉字';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              shNo = value;
                            },
                          ),
                        ),
                        //确定按钮
                        Container(
                          margin: EdgeInsets.fromLTRB(25.0, .0, 25.0, 25.0),
                          // decoration: BoxDecoration(
                          //   color: Color.fromRGBO(255, 255, 255, .2),
                          //   //borderRadius: BorderRadius.circular(35.0)
                          // ),
                          child: FlatButton(
                            child: Text('提交警员数据'),
                            color: Color.fromRGBO(255, 255, 255, .2),
                            onPressed: () {
                              // 添加警员数据
                              // print("添加警员数据:111" +
                              //     code +
                              //     " - " +
                              //     name +
                              //     " " +
                              //     shNo);
                              _showStateDialog("");
                            },
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveCall() async {
    // print(name);
    // print(code);
    // print(shNo);

    // final database = $FloorAppDatabase.databaseBuilder().build();
    // database.then((onValu) {
    //   onValu.userDao.getMaxUser().then((onValue) {
    //     int id = 1;
    //     if (onValue != null) {
    //       id = onValue.id + 1;
    //     }
    //     onValu.userDao.insertUser(User(id, code, name, shNo, ""));
    //   });
    // });
    User _user = User(1, code, name, shNo, "", "0.0", "00:00");
    await DBManager().addData(_user);
  }

  /*图片控件*/
  // Widget _ImageView(imgPath) {
  //   if (imgPath == null) {
  //     return Center(
  //       child: Text("请选择图片或拍照"),
  //     );
  //   } else {
  //     return Image.file(
  //       imgPath,
  //     );
  //   }
  // }

  // /*拍照*/
  // _takePhoto() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     _imgPath = image;
  //   });
  // }

  // /*相册*/
  // _openGallery() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _imgPath = image;
  //   });
  // }
}
