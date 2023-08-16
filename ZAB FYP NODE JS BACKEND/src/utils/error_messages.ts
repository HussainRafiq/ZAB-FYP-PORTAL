export default class ErrorMessages {

  static LOGIN_FAILED_CODE = "00001"
  static LOGIN_FAILED_ACCOUNT_INACTIVE_CODE = "00002"
  static LOGIN_FAILED_ACCOUNT_LOCKED_CODE = "00003"
  static INVALID_TOKEN_CODE = "00004"
  static AUTHENTICATION_FAIL_CODE = "00005"
  static ALREADY_INVITATION_SENDED_CODE = "00006"
  static LAST_SENDING_INVITATION_DATE_PASSED_CODE = "00007"
  static YOUR_GROUP_IS_FINALISED_CODE = "00008"
  static INVITATION_NOT_FOUND_CODE = "00009"
  static ALREADY_IN_SOMEONE_GROUP_CODE = "00010"
  static LAST_DATE_FOR_GROUP_PASSED_CODE = "00011"
  static GROUP_NOT_FOUND_CODE = "00012"
  static MAX_GROUP_MEMBER_CODE = "00013"
  static MIN_GROUP_MEMBER_CODE = "00014"
  static GROUP_IS_NOT_FINALIZED_CODE = "00015"
  static PROPOSAL_NOT_FOUND = "00016"

  static getErrorMessage = (code: string) => {

    if (code == this.LOGIN_FAILED_CODE)
      return "Login Failed ! Please try to login with correct credentials.";
    if (code == this.LOGIN_FAILED_ACCOUNT_INACTIVE_CODE)
      return "Login Failed ! Your account is inactive. Please contact admin";
    if (code == this.LOGIN_FAILED_ACCOUNT_LOCKED_CODE)
      return "Login Failed ! Your account is  locked. Please contact admin";
    if (code == this.INVALID_TOKEN_CODE)
      return "Invalid authentication token passed";
    if (code == this.AUTHENTICATION_FAIL_CODE)
      return "Authentication Failed";
    if (code == this.ALREADY_INVITATION_SENDED_CODE)
      return "Invitation already sended to user";
    if (code == this.LAST_SENDING_INVITATION_DATE_PASSED_CODE)
      return "Invitation date has been passed";
    if (code == this.YOUR_GROUP_IS_FINALISED_CODE)
      return "Your group is finalized";
    if (code == this.INVITATION_NOT_FOUND_CODE)
      return "Invitation not found";
    if (code == this.ALREADY_IN_SOMEONE_GROUP_CODE)
      return "Already member of some one else group";
    if (code == this.LAST_DATE_FOR_GROUP_PASSED_CODE)
      return "Last for group creation has been passed";
    if (code == this.GROUP_NOT_FOUND_CODE)
      return "Group not found";
    if (code == this.MAX_GROUP_MEMBER_CODE)
      return "Group members limit is full";
    if (code == this.MIN_GROUP_MEMBER_CODE)
      return "Please complete your group before finalise the group";
    if (code == this.GROUP_IS_NOT_FINALIZED_CODE)
      return "Please finalized your group before creating proposal";
    if (code == this.PROPOSAL_NOT_FOUND)
      return "Proposal not found";

    return "Some error occurred";
  };









}
