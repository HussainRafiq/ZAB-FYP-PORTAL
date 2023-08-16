import User from "../../models/user.model";
export default class SuccessResponseModel {
  public payload: object | null=null;
  public timestamp: number;

  public constructor(payload: object | null=null) {
    this.payload = payload;
    this.timestamp = Date.now();
  }

  

}
