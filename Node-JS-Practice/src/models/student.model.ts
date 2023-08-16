import User from "./user.model";
import Area from "./area.model";


export default class Student extends User {
  public StudentID?: string ;
  public Section?: string ;
  public Program?: string ;
  constructor(ID: string, USERNAME: string, FIRST_NAME: string, LAST_NAME: string,
    EMAIL: string, PHONE_NUMBER: string, STATUS: string, ROLE: string, IS_VERIFIED: boolean,
    IS_LOCKED: boolean, EXTRA_PROPERTIES: string,
    INSTITUTEID: string, AREAS: Array<Area> | null=null)  {

    super(ID,USERNAME,undefined,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,STATUS,ROLE,IS_VERIFIED,IS_LOCKED,undefined,INSTITUTEID);

    if(EXTRA_PROPERTIES)
    {
      var prop=JSON.parse(EXTRA_PROPERTIES);
      this.StudentID=prop.StudentID;
      this.Section=prop.Section;
      this.Program=prop.Program;
    }
    
  }

}
