import 'package:lmsv4_flutter_app/models/user_model.dart';

class AuthModel {
  UserModel? user;
  String? token;
  bool? isAuthenticated;

  AuthModel({
    this.user,
    this.token,
    this.isAuthenticated,
  });
  void parse(Map map) {
    token = map.containsKey("token") ? map["token"] : null;

    if (map.containsKey("user")) {
      user = UserModel?.fromJson(map["user"]);
    }
  }
}
