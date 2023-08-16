import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/constants/enums.dart';
import 'package:lmsv4_flutter_app/constants/local_storage.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/exceptions/generic_message_exception.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/services/auth.service.dart';
import 'package:lmsv4_flutter_app/services/user.service.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  String AuthStatus = "";
  String currentDataState = DataStates.NONE;

  String? AuthMessage = null;
  UserModel? user = null;

  Future<bool> checkIsAuthenticated() async {
    try {
      bool isAuthenticated = false;
      var prefs = await SharedPreferences.getInstance();
      if (prefs != null &&
          prefs.containsKey(TOKEN_KEY) &&
          prefs.containsKey(AUTH_USER_KEY)) {
        AuthStatus = AuthenticationStatus.AUTHENTICATED;
        user = UserModel.fromJson(jsonDecode(prefs.getString(AUTH_USER_KEY)!));
        isAuthenticated = true;
        notifyListeners();
      }
      if (!isAuthenticated) {
        AuthStatus = AuthenticationStatus.FAILED;
      }
      return isAuthenticated;
    } catch (ex) {
      AuthStatus = AuthenticationStatus.FAILED;
      Logger.Log(LogType.ERROR, "AuthState.checkIsAuthenticated", ex);
      return false;
    }
  }

  Future<void> login(String eamil, String password) async {
    try {
      AuthStatus = AuthenticationStatus.AUTHENTICATING;
      notifyListeners();
      //Check User Authentication
      var auth = await AuthService().login(eamil, password);
      print(auth?.user);
      if (auth == null || !auth.isAuthenticated! || auth.user == null) {
        AuthStatus = AuthenticationStatus.FAILED;
        notifyListeners();
        return;
      }

      Logger.Log(LogType.MESSAGE, "Login", "User Authenticated");
      AuthStatus = AuthenticationStatus.AUTHENTICATED;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(TOKEN_KEY, auth.token.toString());

      prefs.setString(AUTH_USER_KEY, jsonEncode(auth.user!));
      user = auth.user;
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        var exception = ex as GenericMessageException;

        AuthStatus = AuthenticationStatus.FAILED;

        AuthMessage = exception.Message;
        notifyListeners();
        return;
      }

      AuthStatus = AuthenticationStatus.FAILED;
      AuthMessage = SOME_ERROR_OCCURRED + ex.toString();
      notifyListeners();
      Logger.Log(LogType.ERROR, "Error", ex);
      return;
    }
  }

  static Future<void> signup() async {}

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.clear();

    AuthStatus = AuthenticationStatus.FAILED;
    notifyListeners();
  }

  Future<String?> sendForgotPasswordVerificationCode(String email) async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();

      String? verificationCode = await AuthService().forgotPassword(email);
      currentDataState = DataStates.FETCHED;
      notifyListeners();
      return verificationCode;
    } catch (ex) {
      if (ex is GenericMessageException) {
        var exception = ex as GenericMessageException;
        AuthMessage = exception.Message;
        notifyListeners();
        return "";
      }
      currentDataState = DataStates.FAILED;
      Logger.Log(
          LogType.ERROR, "AuthState.sendForgotPasswordVerificationCode", ex);
    }
  }

  Future<String?> verifyVerificationCode(
      String verificationID, String code) async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();

      String? verifiedToken =
          await AuthService().verifyCode(verificationID, code);
      currentDataState = DataStates.FETCHED;
      notifyListeners();
      return verifiedToken;
    } catch (ex) {
      if (ex is GenericMessageException) {
        var exception = ex as GenericMessageException;
        AuthMessage = exception.Message;
      }
      currentDataState = DataStates.FAILED;
      notifyListeners();

      Logger.Log(LogType.ERROR, "AuthState.verifyVerificationCode", ex);

      return null;
    }
  }

  Future<bool?> resetPassword(String verificationID, String password) async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();

      bool? isVerified =
          await AuthService().resetPassword(verificationID, password);
      currentDataState = DataStates.FETCHED;
      notifyListeners();
      return isVerified;
    } catch (ex) {
      if (ex is GenericMessageException) {
        var exception = ex as GenericMessageException;
        AuthMessage = exception.Message;
      }
      currentDataState = DataStates.FAILED;
      notifyListeners();

      Logger.Log(LogType.ERROR, "AuthState.resetPassword", ex);

      return false;
    }
  }
}

class DataStates {
  static const NONE = "None";
  static const FAILED = "Failed";
  static const FETCHING = "Fectching";
  static const FETCHED = "Fectched";
  static const CONNECTIONFAILED = "Connection Failed";
  static const NOTFOUND = "Not Found";
  static const UPLOADING = "Uploading";
}

class AuthenticationStatus {
  static const AUTHENTICATED = "Authenticated";
  static const AUTHENTICATING = "Authenticating";
  static const DEVICELIMITEXCEEDED = "DeviceLimitExceeded";
  static const FAILED = "Failed";
}
