// 警员体温类
class TemperatureData {
  final String cmd;
  final String gps;
  final String id;
  final String ip;
  final String pTime;
  final String raw;
  final String sn;
  final String walk;
  final double wd;

  TemperatureData(
      {this.cmd,
      this.gps,
      this.id,
      this.ip,
      this.pTime,
      this.raw,
      this.sn,
      this.walk,
      this.wd});

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    // 人员数据取得
    //   return TemperatureData(
    //       cmd: json['cmd'],
    //       gps: json['gps'],
    //       id: json['id'],
    //       ip: json['ip'],
    //       pTime: json['ptime'],
    //       raw: json['raw'],
    //       sn: json['sn'],
    //       walk: json['walk'],
    //       wd: double.parse(json['wd'] == null ? 0 : json['wd']));
    // }

    return TemperatureData(
        pTime: json['ptime'],
        sn: json['sn'],
        wd: double.parse(json['wd'] == null ? 0 : json['wd']));
  }
}

// 警员体温基本情报
class GetTemperatureData {
  final int code;
  final List<TemperatureData> data;
  final String msg;

  GetTemperatureData({this.code, this.data, this.msg});

  factory GetTemperatureData.fromJson(Map<String, dynamic> json) {
    // 温度数据解析
    var objData = json['data'] as List;
    List<TemperatureData> dataList =
        objData.map((value) => TemperatureData.fromJson(value)).toList();

    return GetTemperatureData(
        code: json['code'], data: dataList, msg: json['msg']);
  }
}
