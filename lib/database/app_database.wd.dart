part of 'app_database.dart';

class _$TemperatureDao extends TemperatureDao {
  _$TemperatureDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _temperatureInsertionAdapter = InsertionAdapter(
            database,
            'wd',
            (Temperature item) => <String, dynamic>{
                  'wdid': item.wdid,
                  'cmd': item.cmd,
                  'gps': item.gps,
                  'id': item.id,
                  'ip': item.ip,
                  'pTime': item.pTime,
                  'raw': item.raw,
                  'sn': item.sn,
                  'walk': item.walk,
                  'wd': item.wd
                },
            changeListener),
        _temperatureDeletionAdapter = DeletionAdapter(
            database,
            'wd',
            ['wdid'],
            (Temperature item) => <String, dynamic>{
                  'wdid': item.wdid,
                  'cmd': item.cmd,
                  'gps': item.gps,
                  'id': item.id,
                  'ip': item.ip,
                  'pTime': item.pTime,
                  'raw': item.raw,
                  'sn': item.sn,
                  'walk': item.walk,
                  'wd': item.wd
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _temperatureMapper = (Map<String, dynamic> row) => Temperature(
      row['wdid'] as int,
      row['cmd'] as String,
      row['gps'] as String,
      row['id'] as String,
      row['ip'] as String,
      row['pTime'] as String,
      row['raw'] as String,
      row['sn'] as String,
      row['walk'] as String,
      row['wd'] as String);

  final InsertionAdapter<Temperature> _temperatureInsertionAdapter;

  final DeletionAdapter<Temperature> _temperatureDeletionAdapter;

  @override
  Future<List<Temperature>> findAllTemperature() async {
    return _queryAdapter.queryList('SELECT * FROM wd',
        mapper: _temperatureMapper);
  }

  @override
  Future<Temperature> getMaxTemperature(String id) async {
    return _queryAdapter.query(
        'Select * FROM wd where id = ? order by wdid desc limit 1',
        arguments: <dynamic>[id],
        mapper: _temperatureMapper);
  }

  @override
  Stream<List<Temperature>> fetchStreamData() {
    return _queryAdapter.queryListStream('SELECT * FROM wd order by wdid desc',
        tableName: 'wd', mapper: _temperatureMapper);
  }

  @override
  Future<void> deleteTemperature(int id) async {
    await _queryAdapter.queryNoReturn('delete FROM wd where wdid = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertTemperature(Temperature temperature) async {
    await _temperatureInsertionAdapter.insert(
        temperature, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<List<int>> insertAllTemperature(List<Temperature> temperature) {
    return _temperatureInsertionAdapter.insertListAndReturnIds(
        temperature, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<int> deleteAll(List<Temperature> list) {
    return _temperatureDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}
