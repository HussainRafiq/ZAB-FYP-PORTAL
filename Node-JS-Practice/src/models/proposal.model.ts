export default class Proposal {
  public ID?: string;
  public TITLE?: string;
  public GROUP_ID?: string;
  public DESCRIPTION?: string;
  public CREATED_AT?: string;
  public CREATED_BY?: string;
  public UPDATED_AT?: string;
  public UPDATED_BY?: string;
  public INSTITUTEID?: string;
  public IS_DELETED?: boolean;
  
  constructor(
    ID?: string,
    TITLE?: string,
    GROUP_ID?: string,
    DESCRIPTION?: string,
    CREATED_AT?: string,
    CREATED_BY?: string,
    UPDATED_AT?: string,
    UPDATED_BY?: string,
    INSTITUTEID?: string,
    IS_DELETED?: boolean
  ) {
    this.ID = ID;
    this.TITLE = TITLE;
    this.GROUP_ID = GROUP_ID;
    this.DESCRIPTION = DESCRIPTION;
    this.CREATED_AT = CREATED_AT;
    this.CREATED_BY = CREATED_BY;
    this.UPDATED_AT = UPDATED_AT;
    this.UPDATED_BY = UPDATED_BY;
    this.INSTITUTEID = INSTITUTEID;
    this.IS_DELETED = IS_DELETED;
  }
}