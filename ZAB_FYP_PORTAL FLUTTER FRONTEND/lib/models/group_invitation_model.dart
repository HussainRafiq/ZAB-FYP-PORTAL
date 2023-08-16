import 'package:lmsv4_flutter_app/models/student_model.dart';

class GroupInvitationModel {
  int? iD;
  StudentModel? student;
  bool? isSended;
  bool? isAccepted;

  GroupInvitationModel({this.iD, this.student, this.isSended, this.isAccepted});

  GroupInvitationModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    student = json['Student'] != null
        ? new StudentModel.fromJson(json['Student'])
        : null;
    isSended = json['IsSended'] == 1;
    isAccepted = json['IsAccepted'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.student != null) {
      data['Student'] = this.student!.toJson();
    }
    data['IsSended'] = this.isSended;
    data['IsAccepted'] = this.isAccepted;
    return data;
  }
}
