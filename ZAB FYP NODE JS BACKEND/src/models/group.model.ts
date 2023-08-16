import User from "./user.model";
import Area from "./area.model";
import Student from "./student.model";


export default class Group {
  public ID?: string;
  public Students?: Student[] ;
  public Is_Finalized?: boolean ;
  constructor(ID?: string, Students?: Student[], Is_Finalized?: boolean)  {
   this.ID=ID;
   this.Students=Students;
   this.Is_Finalized=Is_Finalized;    
  }

}
