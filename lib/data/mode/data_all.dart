import 'package:floor/floor.dart';

class DataHome {
  XMLHead? xMLHead;

  DataHome({this.xMLHead});

  DataHome.fromJson(Map<String, dynamic> json) {
    xMLHead = json['XML_Head'] != null
        ? new XMLHead.fromJson(json['XML_Head'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.xMLHead != null) {
      data['XML_Head'] = this.xMLHead!.toJson();
    }
    return data;
  }
}

class XMLHead {
  String? listname;
  String? language;
  String? orgname;
  String? updatetime;
  Infos? infos;

  XMLHead(
      {this.listname,
        this.language,
        this.orgname,
        this.updatetime,
        this.infos});

  XMLHead.fromJson(Map<String, dynamic> json) {
    listname = json['Listname'];
    language = json['Language'];
    orgname = json['Orgname'];
    updatetime = json['Updatetime'];
    infos = json['Infos'] != null ? new Infos.fromJson(json['Infos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Listname'] = this.listname;
    data['Language'] = this.language;
    data['Orgname'] = this.orgname;
    data['Updatetime'] = this.updatetime;
    if (this.infos != null) {
      data['Infos'] = this.infos!.toJson();
    }
    return data;
  }
}

class Infos {
  List<DataAll>? info;

  Infos({this.info});

  Infos.fromJson(Map<String, dynamic> json) {
    if (json['Info'] != null) {
      info = <DataAll>[];
      json['Info'].forEach((v) {
        info!.add(new DataAll.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['Info'] = this.info!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@entity
class DataAll {
  @primaryKey
  String? id;

  String? name;
  String? zone;
  String? toldescribe;
  String? description;
  String? tel;
  String? address;
  String? zipcode;
  String? region;
  String? town;
  String? travellinginfo;
  String? opentime;
  String? picture1;
  String? picdescribe1;
  String? picture2;
  String? picdescribe2;
  String? picture3;
  String? picdescribe3;
  String? map;
  String? gov;
  double? px;
  double? py;
  String? orgclass;
  String? class1;
  String? class2;
  String? class3;
  String? level;
  String? website;
  String? parkinginfo;
  double? parkinginfoPx;
  double? parkinginfoPy;
  String? ticketinfo;
  String? remarks;
  String? keyword;
  String? changetime;

  DataAll(
      {this.id,
        this.name,
        this.zone,
        this.toldescribe,
        this.description,
        this.tel,
        this.address,
        this.zipcode,
        this.region,
        this.town,
        this.travellinginfo,
        this.opentime,
        this.picture1,
        this.picdescribe1,
        this.picture2,
        this.picdescribe2,
        this.picture3,
        this.picdescribe3,
        this.map,
        this.gov,
        this.px,
        this.py,
        this.orgclass,
        this.class1,
        this.class2,
        this.class3,
        this.level,
        this.website,
        this.parkinginfo,
        this.parkinginfoPx,
        this.parkinginfoPy,
        this.ticketinfo,
        this.remarks,
        this.keyword,
        this.changetime});

  DataAll.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    zone = json['Zone'];
    toldescribe = json['Toldescribe'];
    description = json['Description'];
    tel = json['Tel'];
    address = json['Add'];
    zipcode = json['Zipcode'];
    region = json['Region'];
    town = json['Town'];
    travellinginfo = json['Travellinginfo'];
    opentime = json['Opentime'];
    picture1 = json['Picture1'];
    picdescribe1 = json['Picdescribe1'];
    picture2 = json['Picture2'];
    picdescribe2 = json['Picdescribe2'];
    picture3 = json['Picture3'];
    picdescribe3 = json['Picdescribe3'];
    map = json['Map'];
    gov = json['Gov'];
    px = json['Px'];
    py = json['Py'];
    orgclass = json['Orgclass'];
    class1 = json['Class1'];
    class2 = json['Class2'];
    class3 = json['Class3'];
    level = json['Level'];
    website = json['Website'];
    parkinginfo = json['Parkinginfo'];
    parkinginfoPx = json['Parkinginfo_Px'];
    parkinginfoPy = json['Parkinginfo_Py'];
    ticketinfo = json['Ticketinfo'];
    remarks = json['Remarks'];
    keyword = json['Keyword'];
    changetime = json['Changetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Zone'] = this.zone;
    data['Toldescribe'] = this.toldescribe;
    data['Description'] = this.description;
    data['Tel'] = this.tel;
    data['Add'] = this.address;
    data['Zipcode'] = this.zipcode;
    data['Region'] = this.region;
    data['Town'] = this.town;
    data['Travellinginfo'] = this.travellinginfo;
    data['Opentime'] = this.opentime;
    data['Picture1'] = this.picture1;
    data['Picdescribe1'] = this.picdescribe1;
    data['Picture2'] = this.picture2;
    data['Picdescribe2'] = this.picdescribe2;
    data['Picture3'] = this.picture3;
    data['Picdescribe3'] = this.picdescribe3;
    data['Map'] = this.map;
    data['Gov'] = this.gov;
    data['Px'] = this.px;
    data['Py'] = this.py;
    data['Orgclass'] = this.orgclass;
    data['Class1'] = this.class1;
    data['Class2'] = this.class2;
    data['Class3'] = this.class3;
    data['Level'] = this.level;
    data['Website'] = this.website;
    data['Parkinginfo'] = this.parkinginfo;
    data['Parkinginfo_Px'] = this.parkinginfoPx;
    data['Parkinginfo_Py'] = this.parkinginfoPy;
    data['Ticketinfo'] = this.ticketinfo;
    data['Remarks'] = this.remarks;
    data['Keyword'] = this.keyword;
    data['Changetime'] = this.changetime;
    return data;
  }
}
