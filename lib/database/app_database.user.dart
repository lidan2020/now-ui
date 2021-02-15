part of 'app_database.dart';

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'code': item.code,
                  'name': item.name,
                  'sn': item.sn,
                  'image': item.image
                },
            changeListener),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'code': item.code,
                  'name': item.name,
                  'sn': item.sn,
                  'image': item.image
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _userMapper = (Map<String, dynamic> row) => User(
      row['id'] as int,
      row['code'] as String,
      row['name'] as String,
      row['sn'] as String,
      row['image'] as String,
      "0.0",
      "00:00");

  final InsertionAdapter<User> _userInsertionAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUser() async {
    return _queryAdapter.queryList('SELECT * FROM user order by id asc',
        mapper: _userMapper);
  }

  @override
  Future<User> getMaxUser() async {
    return _queryAdapter.query('Select * from user order by id desc limit 1',
        mapper: _userMapper);
  }

  @override
  Stream<List<User>> fetchStreamData() {
    return _queryAdapter.queryListStream('SELECT * FROM user order by id desc',
        tableName: 'User', mapper: _userMapper);
  }

  @override
  Future<void> deleteUser(int id) async {
    await _queryAdapter.queryNoReturn('delete from user where id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<List<int>> insertAllUser(List<User> user) {
    return _userInsertionAdapter.insertListAndReturnIds(
        user, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteAll(List<User> list) {
    return _userDeletionAdapter.deleteListAndReturnChangedRows(list);
  }

  //@Query("Update user set wd = :wd ,time = :time where sn = :sn")
  @override
  Future<void> updateUser(String sn, String wd, String pTime) async {
    await _queryAdapter.queryNoReturn(
        'Update user set wd = ? ,time = ? where sn = ?',
        arguments: [
          <dynamic>[sn],
          <dynamic>[wd],
          <dynamic>[pTime]
        ]);
  }
}
