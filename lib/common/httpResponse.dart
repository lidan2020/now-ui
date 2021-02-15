import 'dart:convert';

import 'package:Project_News/database/app_database.dart';
import 'package:Project_News/db/BaseDBProvider.dart';
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
Future<User> fetchUserData() async {
  final response = await http.get('http://118.89.224.59:20005/jcys/shiot/list');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('警员基本数据通信失败');
  }
}

// 警员体温信息取得
Future<GetTemperatureData> fetchTemperature() async {
  GetTemperatureData gd;
  List<Temperature> _wdList = new List();

  int i = 0;
  UserList.forEach((uCode) async {
    final response = await http.get(
        'http://118.89.224.59:20005/jcys/shiot/get/' +
            uCode +
            '?offset=0&cnt=1');

    if (response.statusCode == 200) {
      Temperature td;
      if (i == 0) {
        gd = GetTemperatureData.fromJson(jsonDecode(response.body));
        i++;
      } else {
        td = GetTemperatureData.fromJson(jsonDecode(response.body)).data[0];
      }

      if (td != null) {
        _wdList.add(td);
      }
    } else {
      throw Exception('警员体温数据通信失败');
    }
  });

  _wdList.forEach((onValue) {
    gd.data.add(onValue);
  });

  return gd;
}

Future<GetTemperatureData> fetchTemperatureList(String sn) async {
  final response = await http.get(
      'http://118.89.224.59:20005/jcys/shiot/get/' + sn + '?offset=0&cnt=1');

  if (response.statusCode == 200) {
    return GetTemperatureData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('警员体温数据通信失败');
  }
}

// 当前体温取得
getUserList(int rowId) async {
  List<Temperature> wdList = new List<Temperature>();
  String uCode = UserList[rowId];

  // UserList.forEach((uCode) async {
  final response = await http.get(
      'http://118.89.224.59:20005/jcys/shiot/get/' + uCode + '?offset=0&cnt=1');

  if (response.statusCode == 200) {
    Temperature td;

    if (GetTemperatureData.fromJson(jsonDecode(response.body)).data != null) {
      td = GetTemperatureData.fromJson(jsonDecode(response.body)).data[0];
    }

    if (td != null) {
      //td.wdid = int.parse(td.id);
      //wdList.add(td);
      // 数据库温度写入
      //DBManager().addWdData(td);
      //==============================
      print("通信详细数据");
      print("id:[" +
          td.id +
          "] sn:[" +
          td.sn +
          "] wd:[" +
          td.wd +
          "] time:[" +
          td.pTime +
          "]");
      final database = $FloorAppDatabase.databaseBuilder().build();
      database.then((onValu) {
        onValu.temperatureDao.getMaxTemperature(td.id).then((onValue) {
          print("============================================");
          print("数据库中存在的数据");
          print("id:[" +
              onValue.id +
              "] sn:[" +
              onValue.sn +
              "] wd:[" +
              onValue.wd +
              "] time:[" +
              onValue.pTime +
              "]");
          print("============================================");
          if (onValue == null) {
            onValu.temperatureDao.insertTemperature(td);
            // 修改现有人员温度
            onValu.userDao.updateUser(td.sn, td.wd, td.pTime);
            print("============================================");
            print("添加温度，修改现有人员温度");
            print("============================================");
          }
        });
      }).catchError((e) {
        print(e);
      });
      //==============================
    }
  } else {
    throw Exception('警员体温数据通信失败');
  }
  //});

  return wdList;
}

// 网络数据通信，添加数据库
// _saveHttpWdCall(Temperature temData) {
//   DBManager().addWdData(temData);
// }
// _saveHttpWdCall(Temperature temData) {
//   final database = $FloorAppDatabase.databaseBuilder().build();
//   database.then((onValu) {
//     onValu.temperatureDao.getMaxTemperature(temData.sn).then((onValue) {
//       if (onValue != null) {
//         if (onValue.id != temData.id) {
//           onValu.temperatureDao.insertTemperature(temData);
//         }
//       }
//     });
//   });
// }
