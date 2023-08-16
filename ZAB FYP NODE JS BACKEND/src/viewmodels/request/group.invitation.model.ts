import User from "../../models/user.model";
export default class GroupInvitationRequestModel {
  public user_id: string;

  private constructor(reqbody: any) {
    this.user_id = reqbody?.user_id;
  }

  public static fromReqBody(reqbody: any): GroupInvitationRequestModel {
    return new GroupInvitationRequestModel(reqbody);
  }

}
