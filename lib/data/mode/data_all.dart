class DataAll {
  String? id;
  String title = "尚未資料";
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
  String? px;
  String? py;
  String? orgclass;
  String? class1;
  String? class2;
  String? class3;
  String? siteLevel;
  String? website;
  String? parkinginfo;
  String? parkinginfoPx;
  String? parkinginfoPy;
  String? ticketinfo;
  String? remarks;
  String? keyword;
  String? changetime;

  DataAll(
      {this.id,
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
      this.siteLevel,
      this.website,
      this.parkinginfo,
      this.parkinginfoPx,
      this.parkinginfoPy,
      this.ticketinfo,
      this.remarks,
      this.keyword,
      this.changetime});

  DataAll.fromJson(Map json) {
    id = json['Id'];
    title = json['Title'];
    zone = json['Zone'];
    toldescribe = json['Toldescribe'];
    description = json['Description'];
    tel = json['Tel'];
    address = json['Address'];
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
    siteLevel = json['Site_level'];
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
    data['Title'] = this.title;
    data['Zone'] = this.zone;
    data['Toldescribe'] = this.toldescribe;
    data['Description'] = this.description;
    data['Tel'] = this.tel;
    data['Address'] = this.address;
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
    data['Site_level'] = this.siteLevel;
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
