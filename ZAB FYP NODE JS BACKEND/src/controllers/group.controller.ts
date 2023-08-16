import joi, { number } from "joi";
import { Request, Response } from "express";
import GroupInvitationModel from "../viewmodels/request/group.invitation.model";
import GroupService from "../services/group.service";

import SuccessResponseModel from "../viewmodels/response/succes_response_model";
import GroupInvitation from "../models/group_invitation.model";

import GroupInvitationSchema from "../validators/group.invitation.validator";
import GroupAcceptInvitationSchema from "../validators/group.accept_invitation.validator";
import ErrorResponseModel from "../viewmodels/response/error_response_model";
import ErrorMessages from "../utils/error_messages";
import SettingService from "../services/setting.service";
import SettingsKey from "../utils/settings_key";
import GroupAcceptInvitationRequestModel from "../viewmodels/request/group.accept_invitation.model";
export default class GroupController {
  public groupService: GroupService;

  public static get instance(): GroupController {
    return new GroupController();
  }

  private constructor() {
    this.groupService = GroupService.instance;
  }



  public GroupInvitedStudents = async (req: Request, resp: Response) => {
    try {
      var groupInvitedStudents = <GroupInvitation[] | null>[];
      if (req.query.onlyInvited && req.query.onlyInvited == "true") {
        groupInvitedStudents = await this.groupService.fetchGroupInvited((<any>req).currentUser.id);
      } else {
        groupInvitedStudents = await this.groupService.fetchGroupInvitedUser((<any>req).currentUser.id);
      }
      resp.json(
        new SuccessResponseModel(groupInvitedStudents));
    } catch (error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };



  public Group = async (req: Request, resp: Response) => {
    try {
      let group = await this.groupService.fetchGroup((<any>req).currentUser.id);

      resp.json(
        new SuccessResponseModel(group));
    } catch (error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };

  public getInvitations = async (req: Request, resp: Response) => {
    try {
      let invitations = await this.groupService.fetchInvitations((<any>req).currentUser.id);

      resp.json(
        new SuccessResponseModel(invitations));
    } catch (error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };

  public sendGroupInvitation = async (req: Request, resp: Response) => {

    const validation = GroupInvitationSchema.groupInvitationSchema.validate(req.body);
    if (validation.error) {
      let errorDetails = validation.error.details.map((x) => x.message);
      resp.status(400).send(errorDetails);
      return;
    }
    let invitation = GroupInvitationModel.fromReqBody(req.body);
    var groupInvitedStudents = await this.groupService.fetchGroupInvited((<any>req).currentUser.id);
    if (groupInvitedStudents?.find(x => x.Student?.ID == invitation.user_id)) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.ALREADY_INVITATION_SENDED_CODE));
    }

    var settings = await new SettingService().fetchSetting();
    if (settings != null && settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE]) {
      var lastInvitationDate = Date.parse(settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE] + "");
      if (lastInvitationDate && lastInvitationDate < Date.now()) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LAST_SENDING_INVITATION_DATE_PASSED_CODE));
      }
    }

    var group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    if (group != null && group.Is_Finalized == true) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.YOUR_GROUP_IS_FINALISED_CODE));
    }

    var isInvited = await this.groupService.InviteUser((<any>req).currentUser.id, invitation.user_id);
    if (isInvited) {
      var groupInvitedStudents = await this.groupService.fetchGroupInvited((<any>req).currentUser.id);
      return resp.json(
        new SuccessResponseModel(groupInvitedStudents));
    }

    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  }

  public AcceptInvitationLink = async (req: Request, resp: Response) => {

    const validation = GroupAcceptInvitationSchema.groupAcceptInvitationSchema.validate(req.body);
    if (validation.error) {
      let errorDetails = validation.error.details.map((x) => x.message);
      resp.status(400).send(errorDetails);
      return;
    }
    let accept_Invitation = GroupAcceptInvitationRequestModel.fromReqBody(req.body);
    var groupInvitation = await this.groupService.fetchInvitationByID(parseInt(accept_Invitation.invitation_id));
    if (!groupInvitation || groupInvitation.ReceiverID != (<any>req).currentUser.id || groupInvitation.IsAccepted == true) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.INVITATION_NOT_FOUND_CODE));
    }

    let group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    if (group) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.ALREADY_IN_SOMEONE_GROUP_CODE));
    }
    var settings = await new SettingService().fetchSetting();
    if (settings != null && settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE]) {
      var lastInvitationDate = Date.parse(settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE] + "");
      if (lastInvitationDate && lastInvitationDate < Date.now()) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LAST_DATE_FOR_GROUP_PASSED_CODE));
      }
    }

    var acceptedGroup = await this.groupService.fetchGroup(parseInt(groupInvitation.SenderID ?? "0"));
    if (!acceptedGroup) {
      var insertGroupID = await this.groupService.insertGroup();
      await this.groupService.insertGroupMember(insertGroupID, parseInt(groupInvitation.SenderID ?? "0"), 0, (<any>req).currentUser.id)
      acceptedGroup = await this.groupService.fetchGroup(parseInt(groupInvitation.SenderID ?? "0"));
    }
    if (!acceptedGroup) {
      resp
        .status(500);
    }
    
    
    if (settings != null && settings[SettingsKey.MAX_GROUP_MEMBERS_COUNT]) {
      var maxMember = parseInt(settings[SettingsKey.MAX_GROUP_MEMBERS_COUNT] + "");
      
   
      if (maxMember && (acceptedGroup?.Students?.length ?? 0) >= maxMember) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.MAX_GROUP_MEMBER_CODE));
      }
    }

    await this.groupService.insertGroupMember(parseInt(acceptedGroup?.ID ?? "0"), parseInt(groupInvitation.ReceiverID ?? "0"), parseInt(accept_Invitation.invitation_id), (<any>req).currentUser.id)
    group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    await this.groupService.updateGroupInvitations(true,parseInt( accept_Invitation.invitation_id));
    resp.json(
      new SuccessResponseModel(group));
  }

  
  public FinalizedGroup = async (req: Request, resp: Response) => {
   
    let group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    if (!group) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.GROUP_NOT_FOUND_CODE));
    }
    
    var settings = await new SettingService().fetchSetting();
    if (settings != null && settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE]) {
      var lastInvitationDate = Date.parse(settings[SettingsKey.LAST_INVITED_GROUP_MEMBERS_DATE] + "");
      if (lastInvitationDate && lastInvitationDate < Date.now()) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LAST_DATE_FOR_GROUP_PASSED_CODE));
      }
    }
    if (settings != null && settings[SettingsKey.MAX_GROUP_MEMBERS_COUNT]) {
      var maxMember = parseInt(settings[SettingsKey.MAX_GROUP_MEMBERS_COUNT] + "");
      if (maxMember && (group?.Students?.length ?? 0) > maxMember) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.MAX_GROUP_MEMBER_CODE));
      }
    }

    if (settings != null && settings[SettingsKey.MIN_GROUP_MEMBERS_COUNT]) {
      var minMember = parseInt(settings[SettingsKey.MIN_GROUP_MEMBERS_COUNT] + "");
      if (minMember && (group?.Students?.length ?? 0) < minMember) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.MIN_GROUP_MEMBER_CODE));
      }
    }

    await this.groupService.updateGroup(true, parseInt(group?.ID ?? "0"));
    group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    resp.json(
      new SuccessResponseModel(group));
  }



}
