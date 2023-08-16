import 'dart:convert';
import 'dart:ffi';

import 'package:image_picker/image_picker.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/models/group_invitation_model.dart';
import 'package:lmsv4_flutter_app/models/group_model.dart';
import 'package:lmsv4_flutter_app/utils/Logger.dart';
import '../constants/urls.dart';
import '../utils/api.dart';
import '../utils/globals.dart';

class GroupService {
  Future<GroupModel?> fetchGroup() async {
    try {
      var responses = await APIHelper.makeAPICall(Globals.APIUrl + GET_GROUP,
              isAuthorizeApi: true, method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;
      if (responses != null && responses.containsKey("payload")) {
        return GroupModel.fromJson(responses["payload"]);
      } else if (responses != null && responses.containsKey("error")) {
        CustomToast.ShowMessage((responses["error"] as Map)["message"]);
      }
      return null;
    } catch (ex) {
      Logger.Log(LogType.ERROR, "GroupService.fetchGroup", ex);
      throw ex;
    }
  }

  Future<List<GroupInvitationModel>> getGroupInvitations() async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + GET_GROUP_INVITATIONS,
              isAuthorizeApi: true,
              method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var invitations = (responses["payload"] as List)
            .map((e) => GroupInvitationModel.fromJson(e))
            .toList();
        return invitations;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.getAdvisors", ex);
      throw ex;
    }
  }

  Future<List<GroupInvitationModel>> sendGroupInvitations(String userID) async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + SEND_GROUP_INVITATION,
              isAuthorizeApi: true,
              body: jsonEncode({"user_id": userID}),
              method: HTTPMethod.POST)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var invitations = (responses["payload"] as List)
            .map((e) => GroupInvitationModel.fromJson(e))
            .toList();
        return invitations;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.sendGroupInvitations", ex);
      throw ex;
    }
  }

  Future<bool> acceptGroupInvitations(String invitationID) async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + ACCEPT_GROUP_INVITATION,
              isAuthorizeApi: true,
              body: jsonEncode({"invitation_id": invitationID}),
              method: HTTPMethod.POST)
          .then((value) {
        print(value);
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.acceptGroupInvitations", ex);
      throw ex;
    }
  }

  Future<bool> FinalizeGroup() async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + FINALIZE_GROUP,
              isAuthorizeApi: true,
              method: HTTPMethod.POST)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.acceptGroupInvitations", ex);
      throw ex;
    }
  }

  Future<List<GroupInvitationModel>> fetchGroupInvitations() async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + FETCH_GROUP_INVITATION,
              isAuthorizeApi: true,
              method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var invitations = (responses["payload"] as List)
            .map((e) => GroupInvitationModel.fromJson(e))
            .toList();
        return invitations;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.fetchGroupInvitations", ex);
      throw ex;
    }
  }
}
