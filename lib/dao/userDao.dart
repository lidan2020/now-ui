import 'package:floor/floor.dart';
import 'package:Project_News/model/user.dart';

/// Created by Jai on 15,May,2020

@dao
abstract class UserDao {
  @Query('SELECT * FROM user')
  Future<List<User>> findAllUser();

  @Query('Select * from user order by id desc limit 1')
  Future<User> getMaxUser();

  @Query('SELECT * FROM user order by id desc')
  Stream<List<User>> fetchStreamData();

  @insert
  Future<void> insertUser(User user);

  @insert
  Future<List<int>> insertAllUser(List<User> user);

  @Query("delete from user where id = :id")
  Future<void> deleteUser(int id);

  @delete
  Future<int> deleteAll(List<User> list);

  @Query("Update user set wd = :wd ,time = :time where sn = :sn")
  Future<void> updateUser(String sn, String wd, String pTime);
}
