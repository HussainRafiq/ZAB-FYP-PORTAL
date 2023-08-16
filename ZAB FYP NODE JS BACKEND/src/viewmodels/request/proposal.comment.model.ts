export default class PurposalCommentRequestModel {
  public proposalID: String;
  public comment: String;
  public isInterested: String;

  private constructor(reqbody: any) {
    this.proposalID = reqbody?.proposalID;
    this.comment = reqbody?.comment;
    this.isInterested = reqbody?.isInterested;
  }

  public static fromReqBody(reqbody: any): PurposalCommentRequestModel {
    return new PurposalCommentRequestModel(reqbody);
  }

}
