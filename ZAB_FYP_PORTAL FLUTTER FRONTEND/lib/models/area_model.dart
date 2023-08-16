class AreaModel {
  int? iD;
  String? nAME;
  String? dESCRITION;

  AreaModel({this.iD, this.nAME, this.dESCRITION});

  AreaModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    nAME = json['NAME'];
    dESCRITION = json['DESCRITION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['NAME'] = this.nAME;
    data['DESCRITION'] = this.dESCRITION;
    return data;
  }
}
