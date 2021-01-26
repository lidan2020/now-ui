import 'dart:convert';

import 'package:Project_News/model/temperatureData.dart';
import 'package:Project_News/model/user.dart';
import 'package:http/http.dart' as http;

var UserList = [
  "689464703098034",
  "689464703098620",
  "689464703103511",
  "689464703103800",
  "689464703104550",
  "689464703104576",
  "689464703104592",
  "689464703104634",
  "689464703104659",
  "689464703105821",
  "689464703105862",
  "689464703121851",
  "689464703122909",
  "689464703122933",
  "689464703125084",
  "689464703125118"
];

// 警员用户基本信息取得
Future<UserData> fetchUserData() async {
  final response = await http.get('http://118.89.224.59:20005/jcys/shiot/list');

  if (response.statusCode == 200) {
    return UserData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('警员基本数据通信失败');
  }
}

// 警员体温信息取得
Future<GetTemperatureData> fetchTemperatureData(String count) async {
  GetTemperatureData gd;

  int i = 0;
  UserList.forEach((uCode) async {
    final response = await http.get(
        'http://118.89.224.59:20005/jcys/shiot/get/' +
            uCode +
            '?offset=0&cnt=1');

    if (response.statusCode == 200) {
      TemperatureData td = new TemperatureData();
      if (i == 0) {
        gd = GetTemperatureData.fromJson(jsonDecode(response.body));
        i++;
      } else {
        td = GetTemperatureData.fromJson(jsonDecode(response.body)).data[0];
      }

      if (td != null) {
        gd.data.add(td);
      }
    } else {
      throw Exception('警员体温数据通信失败');
    }
  });

  return gd;
}

Future<GetTemperatureData> fetchTemperatureDataList(String sn) async {
  final response = await http.get(
      'http://118.89.224.59:20005/jcys/shiot/get/689464703098034?offset=0&cnt=1');

  if (response.statusCode == 200) {
    return GetTemperatureData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('警员体温数据通信失败');
  }
}

// 当前体温取得
List<TemperatureData> getUserList() {
  List<TemperatureData> userList = new List<TemperatureData>();

  UserList.forEach((uCode) async {
    final response = await http.get(
        'http://118.89.224.59:20005/jcys/shiot/get/' +
            uCode +
            '?offset=0&cnt=1');

    if (response.statusCode == 200) {
      TemperatureData td = new TemperatureData();

      if (GetTemperatureData.fromJson(jsonDecode(response.body)).data != null) {
        td = GetTemperatureData.fromJson(jsonDecode(response.body)).data[0];
      }

      if (td != null) {
        userList.add(td);
      }
    } else {
      throw Exception('警员体温数据通信失败');
    }
  });

  return userList;
}
