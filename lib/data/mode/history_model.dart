class HistoryModel {
  int? id;
  String? title;
  int? value;

  HistoryModel({
    required int id,
    required String title,
    required int int,
  }) {
    id = id;
    title = title;
    value = int;
  }

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    value = json['Num'];
  }

  HistoryModel copyWith({
    int? id,
    String? title,
    int? int,
  }) {
    return HistoryModel(
      id: id ?? id!,
      title: title ?? title!,
      int: int ?? value!,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Title'] = title;
    map['Num'] = value;
    return map;
  }
}
