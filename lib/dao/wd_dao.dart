import 'package:Project_News/model/temperatureData.dart';
import 'package:floor/floor.dart';

/// Created by Jai on 15,May,2020

@dao
abstract class TemperatureDao {
  @Query('SELECT * FROM Temperature')
  Future<List<Temperature>> findAllTemperature();

  @Query('Select * from Temperature where id = ? order by wdid desc limit 1')
  Future<Temperature> getMaxTemperature(String id);

  @Query('SELECT * FROM Temperature order by wdid desc')
  Stream<List<Temperature>> fetchStreamData();

  @insert
  Future<void> insertTemperature(Temperature temperature);

  @insert
  Future<List<int>> insertAllTemperature(List<Temperature> temperatureList);

  @Query("delete from Temperature where wdid = :wdid")
  Future<void> deleteTemperature(int id);

  @delete
  Future<int> deleteAll(List<Temperature> temperatureList);
}
