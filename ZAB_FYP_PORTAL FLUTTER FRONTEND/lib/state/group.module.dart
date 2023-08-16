import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/models/group_invitation_model.dart';
import 'package:lmsv4_flutter_app/models/group_model.dart';
import 'package:lmsv4_flutter_app/services/advisor.service.dart';
import 'package:lmsv4_flutter_app/services/group.service.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'package:win_toast/win_toast.dart';
import '../components/toaster.dart';
import '../exceptions/generic_message_exception.dart';
import 'auth.module.dart';

class GroupState extends ChangeNotifier {
  String currentDataState = DataStates.NONE;

  GroupModel? group = null;

  Future getGroup() async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();
      group = await GroupService().fetchGroup();
      currentDataState = DataStates.FETCHED;
      notifyListeners();
    } catch (ex) {
      group = null;
      notifyListeners();
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }

      Logger.Log(LogType.ERROR, "GroupState.getGroup", ex);
      return false;
    }
  }

  Future<List<GroupInvitationModel>> getGroupInvitations() async {
    try {
      return await GroupService().getGroupInvitations();
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "GroupState.getGroupInvitations", ex);
      return [];
    }
  }

  Future<List<GroupInvitationModel>> sendGroupInvitations(userID) async {
    try {
      return await GroupService().sendGroupInvitations(userID);
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "GroupState.sendGroupInvitations", ex);
      return [];
    }
  }

  Future<bool> acceptGroupInvitations(invitationID) async {
    try {
      return await GroupService().acceptGroupInvitations(invitationID);
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "GroupState.acceptGroupInvitations", ex);
      return false;
    }
  }

  Future<bool> finalizeGroup() async {
    try {
      return await GroupService().FinalizeGroup();
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "GroupState.finalizeGroup", ex);
      return false;
    }
  }

  Future<List<GroupInvitationModel>> fetchGroupInvitations() async {
    try {
      return await GroupService().fetchGroupInvitations();
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "GroupState.fetchGroupInvitations", ex);
      return [];
    }
  }
}
