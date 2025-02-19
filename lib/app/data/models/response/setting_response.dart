class SettingResponse {
  int statusCode;
  String message;
  SettingData data;
  SettingResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  factory SettingResponse.fromMap(Map<String, dynamic> map) {
    return SettingResponse(
      statusCode: map['statusCode'] as int,
      message: map['message'] as String,
      data: SettingData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }
}

class SettingData {
  bool isForceUpdate;
  bool isMaintenance;
  SettingData({
    required this.isForceUpdate,
    required this.isMaintenance,
  });

  factory SettingData.fromMap(Map<String, dynamic> map) {
    return SettingData(
      isForceUpdate: map['isForceUpdate'] as bool,
      isMaintenance: map['isMaintenance'] as bool,
    );
  }
}
