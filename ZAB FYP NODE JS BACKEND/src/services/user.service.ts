import User from "../models/user.model";
import Dbfactory from "../dbmanager/db.factory";
import Dbmanager from "../dbmanager/db.manager";
import queries from "../scripts/queries";
import CurrentInstitute from "../utils";
import Advisor from "../models/advisor.model";
import Area from "../models/area.model";

export default class UserService {
  private dbmanager: Dbmanager;
  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  public static get instance() {
    return new UserService();
  }
  async fetchUsers(
   id: number | null=null,
   email: string | null=null,
   username: string | null=null,
   firstName: string | null=null,
   lastName: string | null=null, 
   isLocked: boolean | null=null,
   isVerified: boolean | null=null,
   phoneNumber: string | null=null,
   role: string | null=null,
   status: string | null=null,
   loginName: string | null=null,
   searchString: string | null=null
  ): Promise<User[] | null> {    
    var parameters = {
      ID:id, 
      EMAIL:email,
      USERNAME:username,
      FIRST_NAME:firstName,
      LAST_NAME:lastName,
      IS_LOCKED:isLocked,
      IS_VERIFIED:isVerified,
      PHONE_NUMBER:phoneNumber,
      ROLE:role,
      STATUS:status,
      LOGIN_NAME:loginName,
      SEARCH_STRING:searchString,
      INSTITUTEID:await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.filterUser,
      parameters
    );
    let fetchedUser = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!fetchedUser.length) return [];

    return fetchedUser.map(
      (x)=>{
           var user=new User(
           x.ID, x.USERNAME,x.PASSWORD,x.FIRST_NAME ,x.LAST_NAME ,x.EMAIL ,x.PHONE_NUMBER,x.STATUS,
           x.ROLE,x.IS_VERIFIED ,x.IS_LOCKED,x.PROFILE_PIC ,x.EXTRA_PROPERTIES,x.INSTITUTEID);          
        return user;
      }
    );
  }
  async fetchAdvisors(
    firstName: string | null=null,
    lastName: string | null=null, 
    areaIDs: string[] | null=null
   ): Promise<User[] | null> {    
     var parameters = {
       AREA_IDs:areaIDs,
       FIRST_NAME:firstName,
       LAST_NAME:lastName,
       INSTITUTEID:await CurrentInstitute.instance.get("")
     };
     var table = await this.dbmanager.executeQuery(
       queries.filterAdvisor,
       parameters
     );
     let fetchedAdvisors = Array.isArray(table.rows) ? Array.from(table.rows) : [];
     if (!fetchedAdvisors.length) return [];
     
     var advisors=new Map<String,Advisor>();

     fetchedAdvisors.forEach(x => {

       if (!advisors.has(x.ID)) {
         advisors.set(x.ID, new Advisor(
           x.ID, x.USERNAME, x.PASSWORD, x.FIRST_NAME, x.LAST_NAME, x.EMAIL, x.PHONE_NUMBER, x.STATUS,
           x.ROLE,x.PROFILE_PIC, x.IS_VERIFIED, x.IS_LOCKED, x.EXTRA_PROPERTIES, x.INSTITUTEID, []));
       }
       if (advisors.get(x.ID)) {
         var ad = advisors.get(x.ID) as Advisor;
         ad.Areas!.push(new Area(x.AREA_ID, x.AREA_NAME, x.AREA_DESCRIPTION, x.INSTITUTEID));
       }
     });
      var adv=new Array<User>();
      advisors.forEach(function(u,k,m){
          adv.push(u);
      });


     return adv;
   }
 
}
