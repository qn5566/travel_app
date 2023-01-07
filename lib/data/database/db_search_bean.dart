class DbTravelBean {
  int? id;
  String? title; // 搜索词

  DbTravelBean({this.id, required this.title});

  DbTravelBean.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
  }

  Map<String, String?> toJson() {
    var map = <String, String?>{};
    map['Id'] = id?.toString();
    map['Title'] = title ?? "";

    return map;
  }
}
