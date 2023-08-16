export default class PurposalCreateRequestModel {
  public title: String;
  public description: String;

  private constructor(reqbody: any) {
    this.title = reqbody?.title;
    this.description = reqbody?.description;
  }

  public static fromReqBody(reqbody: any): PurposalCreateRequestModel {
    return new PurposalCreateRequestModel(reqbody);
  }

}
