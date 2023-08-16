import 'dart:convert';

import 'package:lmsv4_flutter_app/constants/urls.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/utils/api.dart';
import 'package:lmsv4_flutter_app/utils/globals.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';

class UserService {
  Future<UserModel?> getCurrentUserDetail() async {
    // try {
    //   var user = UserModel();
    //   var responses = await APIHelper.makeAPICall(
    //           Globals.APIUrl + FETCH_CURRENT_USER,
    //           method: HTTPMethod.GET,
    //           isAuthorizeApi: true)
    //       .then((value) {
    //     return value;
    //   }) as Map;
    //   if (responses == null ||
    //       responses.containsKey("error") ||
    //       !responses.containsKey("payload")) {
    //     return null;
    //   } else {
    //     user.fromJson(responses["payload"]);
    //     return user;
    //   }
    // } catch (ex) {
    //   Logger.Log(LogType.ERROR, "UserModel.UserService", ex);
    //   throw ex;
    // }
  }

  Future<UserModel?> updateUserDetail(UserModel user) async {
    // try {
    //   var responses = await APIHelper.makeAPICall(
    //           Globals.APIUrl + PUT_USER_PROFILE,
    //           method: HTTPMethod.PUT,
    //           body: jsonEncode(user),
    //           isAuthorizeApi: true)
    //       .then((value) {
    //     return value;
    //   }) as Map;
    //   if (responses == null ||
    //       responses.containsKey("error") ||
    //       !responses.containsKey("payload")) {
    //     return null;
    //   } else {
    //     user.fromJson(responses["payload"]);
    //     return user;
    //   }
    // } catch (ex) {
    //   Logger.Log(LogType.ERROR, "UserModel.UserService", ex);
    //   throw ex;
    // }
  }

  Future<UserModel?> getUserByID(id) async {
    // try {
    //   var user = UserModel();
    //   var responses = await APIHelper.makeAPICall(
    //           Globals.APIUrl + FETCH_POST_USERS_API + "/$id",
    //           method: HTTPMethod.GET,
    //           isAuthorizeApi: true)
    //       .then((value) {
    //     return value;
    //   }) as Map;
    //   if (responses == null ||
    //       responses.containsKey("error") ||
    //       !responses.containsKey("payload")) {
    //     return null;
    //   } else {
    //     user.fromJson(responses["payload"]);
    //     return user;
    //   }
    // } catch (ex) {
    //   Logger.Log(LogType.ERROR, "UserModel.UserService", ex);
    //   return null;
    // }
  }
}
