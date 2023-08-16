import 'dart:convert';
import 'package:lmsv4_flutter_app/constants/urls.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/utils/Logger.dart';
import '../utils/api.dart';
import '../utils/globals.dart';

class AdvisorService {
  Future<List<AdvisorModel>> getAdvisors() async {
    try {
      var responses = await APIHelper.makeAPICall(Globals.APIUrl + GET_ADVISOR,
              method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var advisors = (responses["payload"] as List)
            .map((e) => AdvisorModel.fromJson(e))
            .toList();
        return advisors;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.getAdvisors", ex);
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
