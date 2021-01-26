// 警员基本信息类
class UserData {
  final int code;
  final int count;
  final List<SnData> data;
  final String msg;

  UserData({this.code, this.count, this.data, this.msg});

  factory UserData.fromJson(Map<String, dynamic> json) {
    // 人员数据解析
    var objData = json['data'] as List;
    List<SnData> dataList =
        objData.map((value) => SnData.fromJson(value)).toList();

    // 人员数据取得
    return UserData(
        code: json['code'],
        count: json['count'],
        data: dataList,
        msg: json['msg']);
  }
}

// 人员基本情报
class SnData {
  final String sn;

  SnData({this.sn});

  factory SnData.fromJson(Map<String, dynamic> json) {
    return SnData(sn: json['sn']);
  }
}
