import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/local_storage.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/exceptions/generic_message_exception.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/services/auth.service.dart';
import 'package:lmsv4_flutter_app/services/group.service.dart';
import 'package:lmsv4_flutter_app/services/user.service.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState extends ChangeNotifier {
  String currentDataState = DataStates.NONE;

  Future<String?> uploadProfilePicture(XFile? file, UserModel user) async {
    // try {
    //   currentDataState = DataStates.UPLOADING;
    //   notifyListeners();
    //   var path = await FileService().upload(file!, "Image", "User");
    //   await updateUserProfile(UserModel(iD: user.iD, profilePicture: path));

    //   currentDataState = DataStates.FETCHED;
    //   notifyListeners();

    //   return path;
    // } catch (ex) {
    //   currentDataState = DataStates.FAILED;
    //   notifyListeners();
    //   Logger.Log(LogType.ERROR, "UserState.uploadProfilePicture", ex);
    //   return "";
    // }
  }

  Future<UserModel?> updateUserProfile(UserModel userProfile) async {
    try {
      currentDataState = DataStates.UPLOADING;
      notifyListeners();
      var user = await UserService().updateUserDetail(userProfile);

      var prefs = await SharedPreferences.getInstance();
      var currentUser = await UserService().getCurrentUserDetail();
      prefs.setString(AUTH_USER_KEY, jsonEncode(currentUser));
      currentDataState = DataStates.FETCHED;
      notifyListeners();

      return currentUser;
    } catch (ex) {
      currentDataState = DataStates.FAILED;
      notifyListeners();
      Logger.Log(LogType.ERROR, "UserState.updateUserProfile", ex);
      if (ex is GenericMessageException) {
        throw ex;
      }
      return null;
    }
  }
}
