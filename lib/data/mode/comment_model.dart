class CommentModel {
  String? comment;
  String? device;
  int? id;
  int? like;
  String? timeStamp;
  String? titleId;
  String? titleName;
  String? username;

  CommentModel(
      {this.comment,
      this.device,
      this.id,
      this.like,
      this.timeStamp,
      this.titleId,
      this.titleName,
      this.username});

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment = json['Comment'];
    device = json['Device'];
    id = json['Id'];
    like = json['Like'];
    timeStamp = json['TimeStamp'];
    titleId = json['TitleId'];
    titleName = json['TitleName'];
    username = json['Username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Comment'] = this.comment;
    data['Device'] = this.device;
    data['Id'] = this.id;
    data['Like'] = this.like;
    data['TimeStamp'] = this.timeStamp;
    data['TitleId'] = this.titleId;
    data['TitleName'] = this.titleName;
    data['Username'] = this.username;
    return data;
  }
}
