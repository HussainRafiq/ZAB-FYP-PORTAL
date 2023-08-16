export default class UserResponseModel{
  public id: string;
  public first_name: string;
  public last_name: string;
  public email: string;
  public phone_number: string;
  public status: string;
  public role: string;
  public is_verified: boolean;
  public is_locked: boolean;
  public extra_properties: string;
  public instituteid: string;
    constructor(ID: string, FIRST_NAME: string, LAST_NAME: string,
      EMAIL: string, PHONE_NUMBER: string, STATUS: string, ROLE: string, IS_VERIFIED: boolean,
      IS_LOCKED: boolean, EXTRA_PROPERTIES: string,
      INSTITUTEID: string) {
  
        this.id=ID;
        this.first_name=FIRST_NAME;
        this.last_name=LAST_NAME;
        this.email=EMAIL;
        this.phone_number=PHONE_NUMBER;
        this.status=STATUS;
        this.role=ROLE;
        this.is_verified=IS_VERIFIED;
        this.is_locked= IS_LOCKED;
        this.extra_properties=EXTRA_PROPERTIES;
        this.instituteid=INSTITUTEID
  
    }
  
  }
  