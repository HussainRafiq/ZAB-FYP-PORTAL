import 'package:lmsv4_flutter_app/models/student_model.dart';

class GroupModel {
  int? iD;
  List<StudentModel>? students;
  bool? isFinalized;

  GroupModel({this.iD, this.students, this.isFinalized});

  GroupModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    if (json['Students'] != null) {
      students = <StudentModel>[];
      json['Students'].forEach((v) {
        students!.add(new StudentModel.fromJson(v));
      });
    }
    isFinalized = json['Is_Finalized'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    if (this.students != null) {
      data['Students'] = this.students!.map((v) => v.toJson()).toList();
    }
    data['Is_Finalized'] = this.isFinalized;
    return data;
  }
}
