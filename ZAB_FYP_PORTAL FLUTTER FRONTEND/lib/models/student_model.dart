class StudentModel {
  int? iD;
  String? uSERNAME;
  String? fIRSTNAME;
  String? lASTNAME;
  String? eMAIL;
  String? pHONENUMBER;
  String? sTATUS;
  String? rOLE;
  int? iSVERIFIED;
  int? iSLOCKED;
  String? eXTRAPROPERTIES;
  String? studentID;
  String? section;
  String? program;

  StudentModel(
      {this.iD,
      this.uSERNAME,
      this.fIRSTNAME,
      this.lASTNAME,
      this.eMAIL,
      this.pHONENUMBER,
      this.sTATUS,
      this.rOLE,
      this.iSVERIFIED,
      this.iSLOCKED,
      this.eXTRAPROPERTIES,
      this.studentID,
      this.section,
      this.program});

  StudentModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    uSERNAME = json['USERNAME'];
    fIRSTNAME = json['FIRST_NAME'];
    lASTNAME = json['LAST_NAME'];
    eMAIL = json['EMAIL'];
    pHONENUMBER = json['PHONE_NUMBER'];
    sTATUS = json['STATUS'];
    rOLE = json['ROLE'];
    iSVERIFIED = json['IS_VERIFIED'];
    iSLOCKED = json['IS_LOCKED'];
    eXTRAPROPERTIES = json['EXTRA_PROPERTIES'];
    studentID = json['StudentID'];
    section = json['Section'];
    program = json['Program'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['USERNAME'] = this.uSERNAME;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['EMAIL'] = this.eMAIL;
    data['PHONE_NUMBER'] = this.pHONENUMBER;
    data['STATUS'] = this.sTATUS;
    data['ROLE'] = this.rOLE;
    data['IS_VERIFIED'] = this.iSVERIFIED;
    data['IS_LOCKED'] = this.iSLOCKED;
    data['EXTRA_PROPERTIES'] = this.eXTRAPROPERTIES;
    data['StudentID'] = this.studentID;
    data['Section'] = this.section;
    data['Program'] = this.program;
    return data;
  }
}
