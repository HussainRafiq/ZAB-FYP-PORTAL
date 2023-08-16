import joi from "joi";
import { Request, Response } from "express";
import SuccessResponseModel from "../viewmodels/response/succes_response_model";
import ProposalService from "../services/proposal.service";
import PurposalCreateRequestModel from "../viewmodels/request/proposal.create.model";
import PurposalSendRequestModel from "../viewmodels/request/proposal.send.model";
import ProposalCreateSchema from "../validators/proposal.create.validator"
import GroupService from "../services/group.service";
import ErrorResponseModel from "../viewmodels/response/error_response_model";
import ErrorMessages from "../utils/error_messages";
import Proposal from "../models/proposal.model";
import UserService from "../services/user.service";
import PurposalCommentRequestModel from "../viewmodels/request/proposal.comment.model";
export default class ProposalController {
  public proposalService: ProposalService;
  public groupService: GroupService;
  public userService: UserService;

  public static get instance(): ProposalController {
    return new ProposalController();
  }

  private constructor() {
    this.groupService = GroupService.instance;
    this.proposalService = ProposalService.instance;
    this.userService =  UserService.instance;
  }

  public createProposal = async (req: Request, resp: Response) => {

    const validation = ProposalCreateSchema.proposalCreateSchema.validate(req.body);
    if (validation.error) {
      let errorDetails = validation.error.details.map((x) => x.message);
      resp.status(400).send(errorDetails);
      return;
    }

    let group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    if (!group) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.GROUP_NOT_FOUND_CODE));
    }
  
    if (!group.Is_Finalized) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.GROUP_IS_NOT_FINALIZED_CODE));
    }

    var requestProposal = PurposalCreateRequestModel.fromReqBody(req.body);
    var purposal =await this.proposalService.insertProposal(requestProposal.title as string,group.ID, requestProposal.description, (<any>req).currentUser.id);
    if (purposal) {
      var addedPurposal = await this.proposalService.fetchProposalByID(purposal);
      return resp.json(
        new SuccessResponseModel(addedPurposal));
    }

    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  };

  public getProposals = async (req: Request, resp: Response) => {
    let user = await this.userService.fetchUsers((<any>req).currentUser.id);
    // console.log(user);
    if((user?.length??0)>0 && user![0].ROLE?.toLowerCase()=="student")
    {
        let group = await this.groupService.fetchGroup((<any>req).currentUser.id);
        if (!group) {
          return resp
            .status(400)
            .json(new ErrorResponseModel(ErrorMessages.GROUP_NOT_FOUND_CODE));
        }
      
        var purposals = await this.proposalService.fetchProposals(group.ID)
        if (purposals) {
          var purposalsResponse = purposals;
          return resp.json(
            new SuccessResponseModel(purposalsResponse));
        }
    }else if((user?.length??0)>0 && user![0].ROLE?.toLowerCase()=="advisor")
    {
        // console.log(user);
        var purposals = await this.proposalService.fetchProposalsByAdvisor(user![0].ID)
        if (purposals) {
          var purposalsResponse = purposals;
          return resp.json(
            new SuccessResponseModel(purposalsResponse));
        }
    }
    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  };


  public getProposalComments = async (req: Request, resp: Response) => {

  // console.log((<any>req).query.ProposalID);
    var purposalComments = await this.proposalService.fetchProposalSComments((<any>req).query.ProposalID)
    if (purposalComments) {
      var purposalsResponse = purposalComments;
      return resp.json(
        new SuccessResponseModel(purposalsResponse));
    }

    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  };


  public sendProposal = async (req: Request, resp: Response) => {


    let group = await this.groupService.fetchGroup((<any>req).currentUser.id);
    if (!group) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.GROUP_NOT_FOUND_CODE));
    }
  
    if (!group.Is_Finalized) {
      return resp
        .status(400)
        .json(new ErrorResponseModel(ErrorMessages.GROUP_IS_NOT_FINALIZED_CODE));
    }

    var requestSendProposal = PurposalSendRequestModel.fromReqBody(req.body);
    //check proposal exist in user group
    var proposals = await this.proposalService.fetchProposals(group.ID)
    if (proposals && !(proposals.find(x=>x.ID==requestSendProposal.proposalID))) {
      return resp
      .status(400)
      .json(new ErrorResponseModel(ErrorMessages.PROPOSAL_NOT_FOUND));
    }

    var purposal =await this.proposalService.insertSendProposal(requestSendProposal.proposalID,requestSendProposal.advisorID);
    if (purposal) {
      var sendedPurposal = await this.proposalService.fetchProposalByID(parseInt(requestSendProposal.proposalID as string));
      return resp.json(
        new SuccessResponseModel(sendedPurposal));
    }

    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  };

  public insertProposalComment = async (req: Request, resp: Response) => {


    var requestProposal = PurposalCommentRequestModel.fromReqBody(req.body);
    var purposalComment =await this.proposalService.insertProposalComment(requestProposal.proposalID as string,requestProposal.comment, (<any>req).currentUser.id, requestProposal.isInterested);
    if (purposalComment) {
      var purposalComments = await this.proposalService.fetchProposalSComments(requestProposal.proposalID);
      return resp.json(
        new SuccessResponseModel(purposalComments));
    }

    return resp
      .status(500)
      .json(new ErrorResponseModel(""));

  };



}
