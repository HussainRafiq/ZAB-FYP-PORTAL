import User from "./user.model";
import Area from "./area.model";
import Student from "./student.model";


export default class GroupInvitation {
  
  public ID?: number ;
  public Student?: Student ;
  public SenderID?: string ;
  public ReceiverID?: string ;
  public IsSended?: boolean ;
  public IsAccepted?: boolean ;
  public SendedAt?: Date ;
  constructor(ID: number,Student: Student|undefined, IsSended: boolean, IsAccepted: boolean, SendedAt: Date,SenderID?: string ,ReceiverID?: string)  {
      console.log(IsAccepted==false);
  this.ID=ID;
   this.Student=Student;
   this.IsSended=IsSended;
   this.IsAccepted=IsAccepted;
   this.SendedAt=SendedAt;
   this.SenderID=SenderID;
   this.ReceiverID=ReceiverID;
    
  }
  

}
