import User from "../../models/user.model";
import ErrorMessages from "../../utils/error_messages";
export default class ErrorResponseModel {
  public code: string;
  public message: string;

  public constructor(code: string) {
    this.code=code;
    this.message=ErrorMessages.getErrorMessage(code);
  }

  

}
