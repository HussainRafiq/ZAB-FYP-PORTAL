import 'area_model.dart';

class AdvisorModel {
  int? iD;
  String? fIRSTNAME;
  String? lASTNAME;
  String? eMAIL;
  String? pROFILEPIC;
  String? dESIGNATION;
  String? roomNo;
  String? campus;
  List<AreaModel>? areas;

  AdvisorModel(
      {this.iD,
      this.fIRSTNAME,
      this.lASTNAME,
      this.eMAIL,
      this.pROFILEPIC,
      this.dESIGNATION,
      this.roomNo,
      this.campus,
      this.areas});

  AdvisorModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fIRSTNAME = json['FIRST_NAME'];
    lASTNAME = json['LAST_NAME'];
    eMAIL = json['EMAIL'];
    dESIGNATION = json['DESIGNATION'];
    pROFILEPIC = json['PROFILE_PIC'];
    roomNo = json['RoomNo'];
    campus = json['Campus'];
    if (json['Areas'] != null) {
      areas = <AreaModel>[];
      json['Areas'].forEach((v) {
        areas!.add(new AreaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['EMAIL'] = this.eMAIL;
    data['DESIGNATION'] = this.dESIGNATION;
    data['PROFILE_PIC'] = this.pROFILEPIC;
    data['RoomNo'] = this.roomNo;
    data['Campus'] = this.campus;
    if (this.areas != null) {
      data['Areas'] = this.areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
