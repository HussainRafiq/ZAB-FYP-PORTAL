import User from "../../models/user.model";
export default class LoginUserRequestModel {
  public username: string;
  public password: string;

  private constructor(reqbody: any) {
    this.username = reqbody?.username;
    this.password = reqbody?.password;
  }

  public static fromReqBody(reqbody: any): LoginUserRequestModel {
    return new LoginUserRequestModel(reqbody);
  }

}
