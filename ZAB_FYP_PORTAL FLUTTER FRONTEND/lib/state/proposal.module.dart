import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/models/group_invitation_model.dart';
import 'package:lmsv4_flutter_app/models/group_model.dart';
import 'package:lmsv4_flutter_app/models/proposal_model.dart';
import 'package:lmsv4_flutter_app/services/advisor.service.dart';
import 'package:lmsv4_flutter_app/services/group.service.dart';
import 'package:lmsv4_flutter_app/services/proposal.service.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'package:win_toast/win_toast.dart';
import '../components/toaster.dart';
import '../exceptions/generic_message_exception.dart';
import 'auth.module.dart';

class ProposalState extends ChangeNotifier {
  String currentDataState = DataStates.NONE;

  List<ProposalModel>? proposals = null;

  Future getProposals() async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();
      proposals = await ProposalService().getProposals();
      currentDataState = DataStates.FETCHED;
      notifyListeners();
    } catch (ex) {
      proposals = null;
      notifyListeners();
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }

      Logger.Log(LogType.ERROR, "ProposalState.getProposals", ex);
      return false;
    }
  }

  Future<List<dynamic>> getProposalComments(proposalID) async {
    try {
      var comments = await ProposalService().getProposalComments("$proposalID");
      return comments;
    } catch (ex) {
      proposals = null;
      notifyListeners();
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }

      Logger.Log(LogType.ERROR, "ProposalState.getProposalComments", ex);
      return [];
    }
  }

  Future<ProposalModel?> addProposal(title, description) async {
    try {
      return await ProposalService().createProposal(title, description);
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "ProposalState.addProposal", ex);
      return null;
    }
  }

  Future<ProposalModel?> sendProposal(propoaslID, advisorID) async {
    try {
      return await ProposalService().sendProposal(propoaslID, advisorID);
      notifyListeners();
    } catch (ex) {
      if (ex is GenericMessageException) {
        CustomToast.ShowMessage((ex as GenericMessageException).Message);
      }
      Logger.Log(LogType.ERROR, "ProposalState.sendProposal", ex);
      return null;
    }
  }
}
