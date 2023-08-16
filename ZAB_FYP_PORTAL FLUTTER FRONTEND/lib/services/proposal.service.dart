import 'dart:convert';
import 'package:lmsv4_flutter_app/constants/urls.dart';
import 'package:lmsv4_flutter_app/exceptions/generic_message_exception.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/models/auth_model.dart';
import 'package:lmsv4_flutter_app/models/proposal_model.dart';
import 'package:lmsv4_flutter_app/utils/Logger.dart';
import '../utils/api.dart';
import '../utils/globals.dart';

class ProposalService {
  Future<List<ProposalModel>> getProposals() async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + GET_CREATE_PROPOSAL,
              isAuthorizeApi: true,
              method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;
      print("Test--------------");
      print(responses);
      if (responses != null && responses.containsKey("payload")) {
        var proposals = (responses["payload"] as List)
            .map((e) => ProposalModel.fromJson(e))
            .toList();
        return proposals;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.getProposals",
          (ex as GenericMessageException).Message);
      throw ex;
    }
  }

  Future<List<dynamic>> getProposalComments(proposalID) async {
    try {
      print("Tets Log");
      print(proposalID);
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + '/api/Proposal/comment?ProposalID=' + proposalID,
              isAuthorizeApi: true,
              method: HTTPMethod.GET)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var proposalComments =
            (responses["payload"] as List).map((e) => e).toList();
        return proposalComments;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AdvisorService.getProposalComments",
          (ex as GenericMessageException).Message);
      throw ex;
    }
  }

  Future<ProposalModel?> createProposal(title, description) async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + GET_CREATE_PROPOSAL,
              body: jsonEncode({"title": title, "description": description}),
              method: HTTPMethod.POST)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var proposal = ProposalModel.fromJson(responses["payload"]);
        return proposal;
      } else {
        return null;
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "ProposalService.createProposal", ex);
      throw ex;
    }
  }

  Future<List<dynamic>> addProposalComment(
      proposalID, comment, isInterested) async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + GET_CREATE_PROPOSAL + "/comment",
              body: jsonEncode({
                "proposalID": proposalID,
                "comment": comment,
                "isInterested": isInterested
              }),
              method: HTTPMethod.POST)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var proposalComments =
            (responses["payload"] as List).map((e) => e).toList();
        return proposalComments;
      } else {
        return [];
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "ProposalService.createProposal", ex);
      throw ex;
    }
  }

  Future<ProposalModel?> sendProposal(proposalID, advisorID) async {
    try {
      var responses = await APIHelper.makeAPICall(
              Globals.APIUrl + POST_SEND_PROPOSAL,
              body: jsonEncode(
                  {"proposalID": proposalID, "advisorID": advisorID}),
              method: HTTPMethod.POST)
          .then((value) {
        return value;
      }) as Map;

      if (responses != null && responses.containsKey("payload")) {
        var proposal = ProposalModel.fromJson(responses["payload"]);
        return proposal;
      } else {
        return null;
      }
    } catch (ex) {
      Logger.Log(LogType.ERROR, "ProposalService.createProposal", ex);
      throw ex;
    }
  }
}
