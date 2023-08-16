export default class User {
  public ID?: string;
  public USERNAME?: string;
  public PASSWORD?: string;
  public FIRST_NAME?: string;
  public LAST_NAME?: string;
  public EMAIL?: string;
  public PHONE_NUMBER?: string;
  public STATUS?: string;
  public ROLE?: string;
  public IS_VERIFIED?: boolean;
  public IS_LOCKED?: boolean;
  public PROFILE_PIC?: string;
  public EXTRA_PROPERTIES?: string;
  public INSTITUTEID?: string;
  constructor(ID?: string, USERNAME?: string, PASSWORD?: string , FIRST_NAME?: string, LAST_NAME?: string,
    EMAIL?: string, PHONE_NUMBER?: string, STATUS?: string, ROLE?: string, IS_VERIFIED?: boolean,
    IS_LOCKED?: boolean, PROFILE_PIC?: string, EXTRA_PROPERTIES?: string,
    INSTITUTEID?: string) {

    this.ID=ID;
    this.USERNAME=USERNAME;
    this.PASSWORD=PASSWORD;
    this.FIRST_NAME=FIRST_NAME;
    this.LAST_NAME=LAST_NAME;
    this.EMAIL=EMAIL;
    this.PHONE_NUMBER=PHONE_NUMBER;
    this.STATUS=STATUS;
    this.ROLE=ROLE;
    this.IS_VERIFIED=IS_VERIFIED;
    this.IS_LOCKED= IS_LOCKED;
    this.PROFILE_PIC=PROFILE_PIC;
    this.EXTRA_PROPERTIES=EXTRA_PROPERTIES;
    this.INSTITUTEID=INSTITUTEID

  }

}
