import 'dart:async';

import 'package:Project_News/dao/userDao.dart';
import 'package:Project_News/dao/wd_dao.dart';
import 'package:Project_News/model/temperatureData.dart';
import 'package:floor/floor.dart';
import 'package:Project_News/model/user.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

/// Created by Jai on 15,May,2020
part 'app_database.g.dart'; // the generated code will be there
part 'app_database.user.dart';
part 'app_database.wd.dart';

final String db_name = "wdbase1.db";

@Database(version: 1, entities: [Temperature])
abstract class AppDatabase extends FloorDatabase {
  TemperatureDao get temperatureDao;
  UserDao get userDao;
}
