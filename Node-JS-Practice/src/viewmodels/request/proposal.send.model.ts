export default class PurposalSendRequestModel {
  public proposalID: String;
  public advisorID: String;

  private constructor(reqbody: any) {
    this.proposalID = reqbody?.proposalID;
    this.advisorID = reqbody?.advisorID;
  }

  public static fromReqBody(reqbody: any): PurposalSendRequestModel {
    return new PurposalSendRequestModel(reqbody);
  }

}
