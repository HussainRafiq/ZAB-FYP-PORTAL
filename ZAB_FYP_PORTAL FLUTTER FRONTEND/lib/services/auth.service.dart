import 'dart:convert';
import 'package:lmsv4_flutter_app/constants/urls.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/utils/Logger.dart';
import '../utils/api.dart';
import '../utils/globals.dart';

class AuthService {
  Future<AuthModel?> login(String eamil, String password) async {
    try {
      var auth = AuthModel();
      var request = {"username": eamil, "password": password};

      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + POST_USER_LOGIN,
              body: jsonEncode(request),
              method: HTTPMethod.POST,
              isLoginApi: true)
          .then((value) {
        return value;
      }) as Map;
      if (responses != null && responses.containsKey("payload")) {
        auth.isAuthenticated = true;
        auth.parse(responses["payload"]);
        return auth;
      } else if (responses != null && responses.containsKey("error")) {
        return AuthModel(isAuthenticated: false);
      } else {
        return null;
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AuthService.login", ex);
      throw ex;
    }
  }

  Future<String?> forgotPassword(String email) async {
    // try {
    //   var responses = await APIHelper.makeAPICall(
    //           "${Globals.APIUrl}${SEND_VERIFICATION_TOKEN}?Type=forgotpassword&Email=${email}",
    //           method: HTTPMethod.GET,
    //           isLoginApi: false,
    //           isAuthorizeApi: false)
    //       .then((value) {
    //     return value;
    //   }) as Map;
    //   if (responses != null && responses.containsKey("payload")) {
    //     var response = (responses["payload"] as Map);
    //     return "${response.containsKey("verificationID") ? response["verificationID"] : ""}";
    //   } else {
    //     return null;
    //   }
    // } catch (ex) {
    //   Logger.Log(LogType.ERROR, "AuthService.forgotPassword", ex);
    //   throw ex;
    // }
  }

  Future<String?> verifyCode(String verificationID, String code) async {
    // try {
    //   var body = {
    //     "verificationID": "$verificationID",
    //     "verificationToken": "$code"
    //   };
    //   var responses = await APIHelper.makeAPICall(
    //           "${Globals.APIUrl}${VERIFY_VERIFICATION_CODE}",
    //           method: HTTPMethod.POST,
    //           body: jsonEncode(body),
    //           isLoginApi: false,
    //           isAuthorizeApi: false)
    //       .then((value) {
    //     return value;
    //   }) as Map;
    //   if (responses != null && responses.containsKey("payload")) {
    //     var response = (responses["payload"] as Map);
    //     return response.containsKey("token") ? response["token"] : null;
    //   } else {
    //     return null;
    //   }
    // } catch (ex) {
    //   Logger.Log(LogType.ERROR, "AuthService.forgotPassword", ex);
    //   throw ex;
    // }
  }

  Future<bool?> resetPassword(String verificationID, String password) async {
    //   try {
    //     var body = {
    //       "verificationID": "$verificationID",
    //       "resetPassword": "$password"
    //     };
    //     var responses = await APIHelper.makeAPICall(
    //             "${Globals.APIUrl}${USER_RESET_PASSWORD}",
    //             method: HTTPMethod.POST,
    //             body: jsonEncode(body),
    //             isLoginApi: false,
    //             isAuthorizeApi: false)
    //         .then((value) {
    //       return value;
    //     }) as Map;
    //     if (responses != null && responses.containsKey("payload")) {
    //       return true;
    //     } else {
    //       return null;
    //     }
    //   } catch (ex) {
    //     Logger.Log(LogType.ERROR, "AuthService.forgotPassword", ex);
    //     throw ex;
    //   }
  }
}
