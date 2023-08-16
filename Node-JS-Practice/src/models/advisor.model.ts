import User from "./user.model";
import Area from "./area.model";


export default class Advisor extends User {
  public DESIGNATION?: string ;
  public RoomNo?: string ;
  public Campus?: string ;
  public Areas?: Array<Area> ;
  constructor(ID: string, USERNAME: string, PASSWORD: string, FIRST_NAME: string, LAST_NAME: string,
    EMAIL: string, PHONE_NUMBER: string, STATUS: string, ROLE: string, PROFILE_PIC: string, IS_VERIFIED: boolean,
    IS_LOCKED: boolean, EXTRA_PROPERTIES: string,
    INSTITUTEID: string, AREAS: Array<Area> | null=null)  {

    super(ID,USERNAME,PASSWORD,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,STATUS,ROLE,IS_VERIFIED,IS_LOCKED,PROFILE_PIC,undefined,INSTITUTEID);

    if(EXTRA_PROPERTIES)
    {
      var prop=JSON.parse(EXTRA_PROPERTIES);
      this.DESIGNATION=prop.Designation;
      this.RoomNo=prop.RoomNo;
      this.Campus=prop.Campus;
    }
    
    if(AREAS)
    this.Areas=AREAS;

    
  }

}
