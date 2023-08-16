class UserModel {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? phoneNumber;
  String? status;
  int? isVerified;
  int? isLocked;
  dynamic? extraProperties;
  String? instituteid;

  UserModel(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.role,
      this.phoneNumber,
      this.status,
      this.isVerified,
      this.isLocked,
      this.extraProperties,
      this.instituteid});

  UserModel.fromJson(Map<String, dynamic> json) {
    print("json");
    print(json);
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    role = json['role'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    isVerified = json['is_verified'];
    isLocked = json['is_locked'];
    extraProperties = json['extra_properties'];
    instituteid = json['instituteid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['is_verified'] = this.isVerified;
    data['is_locked'] = this.isLocked;
    data['extra_properties'] = this.extraProperties;
    data['instituteid'] = this.instituteid;
    return data;
  }
}
