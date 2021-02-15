import 'dart:io';
import 'package:Project_News/model/temperatureData.dart';
import 'package:Project_News/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
part 'db_manager.dart';

// 数据库版本
const int VERSION = 1;
const String DB_NAME = "wdbase1.db";

// 人员数据表
const String UserTable =
    'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `code` TEXT, `name` TEXT, `sn` TEXT, `image` TEXT, `wd` TEXT, `time` TEXT)';
// 手环数据表
const String TemperatureTable =
    'CREATE TABLE IF NOT EXISTS `Wd` (`wdid` INTEGER PRIMARY KEY AUTOINCREMENT, `cmd` TEXT, `gps` TEXT, `id` TEXT, `ip` TEXT, `pTime` TEXT, `raw` TEXT, `sn` TEXT, `walk` TEXT, `wd` TEXT)';

//创建数据库
Future<Database> createDataBase() async {
  //在文档目录建立
  //var document = await getApplicationDocumentsDirectory();
  Database db;
  //获取路径 join是path包下的方法，就是将两者路径连接起来
  //String path = join(document.path, db_name);
  final path =
      DB_NAME != null ? join(await getDatabasesPath(), DB_NAME) : ':memory:';
  //逻辑是如果数据库存在就把它删除然后创建
  var _directory = new Directory(dirname(path));
  bool exists = await _directory.exists();
  if (exists) {
    db = await openDatabase(path, version: VERSION);
    if (await isTableExits("user") == false) {
      await db.execute(UserTable);
    }
    if (await isTableExits("Wd") == false) {
      await db.execute(TemperatureTable);
    }
  } else {
    try {
      //不存在则创建目录  如果[recursive]为false，则只有路径中的最后一个目录是
      //创建。如果[recursive]为真，则所有不存在的路径
      //被创建。如果目录已经存在，则不执行任何操作。
      await new Directory(dirname(path)).create(recursive: true);
      //打开数据库
      Database myDb = await openDatabase(path, version: VERSION);
      //创建数据库表
      await myDb.execute(UserTable);
      await myDb.execute(TemperatureTable);
      //关闭数据库
      await myDb.close();
    } catch (e) {
      print(e);
    }
  }
  return db;
}

//判断表是否存在
isTableExits(String tableName) async {
  final path =
      DB_NAME != null ? join(await getDatabasesPath(), DB_NAME) : ':memory:';
  Database db = await openDatabase(path, version: VERSION);
  //内建表sqlite_master
  var sql =
      "SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = '$tableName'";
  var res = await db.rawQuery(sql);
  var returnRes = res != null && res.length > 0;
  return returnRes;
}

//创建数据库表方法
// cratedb_table() async {
//   //得到数据库的路径
//   myDataBasePath = await createDataBase();
//   //打开数据库
//   Database myDb = await openDatabase(myDataBasePath, version: VERSION);
//   //创建数据库表
//   await myDb.execute(UserTable);
//   await myDb.execute(TemperatureTable);

//   //关闭数据库
//   await myDb.close();
//   // setState(() {
//   //   _data = "创建usermessage.db成功，创建user表成功~";
//   // });
// }
