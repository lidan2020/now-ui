// 警员体温类
class Temperature {
  int wdid;
  final String cmd;
  final String gps;
  final String id;
  final String ip;
  final String pTime;
  final String raw;
  final String sn;
  final String walk;
  final String wd;

  Temperature(this.wdid, this.cmd, this.gps, this.id, this.ip, this.pTime,
      this.raw, this.sn, this.walk, this.wd);

  factory Temperature.fromJson(Map<String, dynamic> json) {
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

    return Temperature(
        int.parse(json['id']),
        json['cmd'] == "" ? "0" : json['cmd'],
        json['gps'] == null ? "0" : json['gps'],
        json['id'] == "" ? "0" : json['id'],
        json['ip'] == "" ? "0" : json['ip'],
        json['ptime'] == "" ? "0" : json['ptime'],
        json['raw'] == "" ? "0" : json['raw'],
        json['sn'] == "" ? "0" : json['sn'],
        json['walk'] == "" ? "0" : json['walk'],
        json['wd'] == null ? "0" : json['wd']);
  }
}

// 警员体温基本情报
class GetTemperatureData {
  final int code;
  final List<Temperature> data;
  final String msg;

  GetTemperatureData({this.code, this.data, this.msg});

  factory GetTemperatureData.fromJson(Map<String, dynamic> json) {
    // 温度数据解析
    var objData = json['data'] as List;
    List<Temperature> dataList =
        objData.map((value) => Temperature.fromJson(value)).toList();

    return GetTemperatureData(
        code: json['code'], data: dataList, msg: json['msg']);
  }
}
