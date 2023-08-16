import 'area_model.dart';

class ProposalModel {
  int? iD;
  String? title;
  String? description;
  List<dynamic>? sendedProposals;

  ProposalModel({this.iD, this.title, this.description});

  ProposalModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['TITLE'];
    description = json['DESCRIPTION'];
    sendedProposals = json["SendProposals"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['TITLE'] = this.title;
    data['DESCRIPTION'] = this.description;
    data['SendProposals'] = this.sendedProposals;
    return data;
  }
}
