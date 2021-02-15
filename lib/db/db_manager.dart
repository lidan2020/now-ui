part of 'BaseDBProvider.dart';

class DBManager {
  //增加方法
  addData(User _user) async {
    //首先打开数据库
    Database myDb = await createDataBase();
    int _add_MaxId = 1;
    String get_MaxId = "Select id from user order by id desc";
    try {
      _add_MaxId = Sqflite.firstIntValue(await myDb.rawQuery(get_MaxId));
      if (_add_MaxId == null) {
        _add_MaxId = 1;
      } else {
        _add_MaxId = _add_MaxId + 1;
      }
    } catch (e) {
      _add_MaxId = _add_MaxId + 1;
    }
    String code = _user.code;
    String name = _user.name;
    String sn = _user.sn;
    String image = _user.image;

    //插入数据
    String add_sql =
        "INSERT INTO user(id,code,name,sn,image) VALUES('$_add_MaxId','$code','$name','$sn','$image')";
    await myDb.transaction((tran) async {
      await tran.rawInsert(add_sql);
    }).catchError((e) {
      print(e);
      return false;
    });
    //关闭数据库
    await myDb.close();

    return true;
  }

  //查询具体数值
  Future<List<User>> queryUserAllList() async {
    String sql_userAll = "select * from user";
    List<User> _userList = List();
    //打开数据库
    Database myDb = await createDataBase();

    try {
      //将数据放到集合里面显示
      List<Map> dataList = await myDb.rawQuery(sql_userAll);

      dataList.forEach((dUser) {
        User wdUser = User.fromJson(dUser);
        //查询温度
        String sql_wd = "select wd from wd where sn = '" +
            wdUser.sn +
            "' order by id desc limit 1";
        myDb.rawQuery(sql_wd).then((wdList) {
          if (wdList != null) {
            wdUser.wd = wdList[0].toString();
          }
        });

        _userList.add(wdUser);
      });
    } catch (e) {
      print(e);
    }

    myDb.close();

    return _userList;
  }

  //添加温度
  addWdData(Temperature _wd) async {
    //首先打开数据库
    Database myDb = await createDataBase();

    try {
      int _add_MaxId = 1;
      String sqlid = "";
      // 判断是否存在 id
      String get_Id = "Select id from wd where id = '" + _wd.id + "'";
      try {
        var getIdList = await myDb.rawQuery(get_Id);
        if (getIdList != null) {
          if (getIdList[0].toString() == _wd.id) {
            myDb.close();
            return;
          }
        }
      } catch (e) {
        print(e);
      }

      // 查找编号
      String get_MaxId = "Select wdid from wd order by wdid desc";
      try {
        _add_MaxId = Sqflite.firstIntValue(await myDb.rawQuery(get_MaxId));
        if (_add_MaxId == null) {
          _add_MaxId = 1;
        } else {
          _add_MaxId = _add_MaxId + 1;
        }
      } catch (e) {
        _add_MaxId = _add_MaxId + 1;
      }

      //String wdid = _add_MaxId;
      String cmd = _wd.cmd;
      String gps = _wd.gps;
      String id = _wd.id;
      String ip = _wd.ip;
      String pTime = _wd.pTime;
      String raw = _wd.raw;
      String sn = _wd.sn;
      String walk = _wd.walk;
      String wd = _wd.wd;

      //插入数据
      String add_sql =
          "INSERT INTO wd(wdid,cmd,gps,id,ip,pTime,raw,sn,walk,wd) VALUES('$_add_MaxId','$cmd','$gps','$id','$ip','$pTime','$raw','$sn','$walk','$wd')";
      await myDb.transaction((tran) async {
        await tran.rawInsert(add_sql);
      }).catchError((e) {
        print(e);
        return false;
      });
    } catch (e) {
      print(e);
    }
    //关闭数据库
    myDb.close();

    return true;
  }

  // 提取主页基本信息
  getHomeUI() {}
}
