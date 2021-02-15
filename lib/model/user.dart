/// 警员基本信息类
import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String code;
  final String name;
  final String sn;
  final String image;
  String wd;
  String time;

  //User(int row, {this.id,this.code, this.name, this.sn, this.image});
  User(this.id, this.code, this.name, this.sn, this.image, this.wd, this.time);

  factory User.fromJson(Map<String, dynamic> json) {
    /// 人员数据解析
    /// 人员数据取得
    return User(0, json['code'], json['name'], json['sn'], json['image'], "0.0",
        "00:00");
  }
}

/// 人员基本情报
class SnData {
  final String sn;

  SnData({this.sn});

  factory SnData.fromJson(Map<String, dynamic> json) {
    return SnData(sn: json['sn']);
  }
}
