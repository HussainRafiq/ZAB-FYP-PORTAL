import User from "../../models/user.model";
export default class GroupAcceptInvitationRequestModel {
  public invitation_id: string;

  private constructor(reqbody: any) {
    this.invitation_id = reqbody?.invitation_id;
  }

  public static fromReqBody(reqbody: any): GroupAcceptInvitationRequestModel {
    return new GroupAcceptInvitationRequestModel(reqbody);
  }

}
