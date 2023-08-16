import User from "../models/user.model";
import Dbfactory from "../dbmanager/db.factory";
import Dbmanager from "../dbmanager/db.manager";
import queries from "../scripts/queries";
import CurrentInstitute from "../utils";
import Area from "../models/area.model";

export default class AreaService {
  private dbmanager: Dbmanager;
  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  public static get instance() {
    return new AreaService();
  }
  async fetchAreas(
   id: number | null=null,
   name: string | null=null): Promise<Area[] | null> {    
    var parameters = {
      ID:id, 
      NAME:name?`%${name}%`:null,
      INSTITUTEID:await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.filterArea,
      parameters
    );
    let fetchedAreas = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!fetchedAreas.length) return [];

    return fetchedAreas.map(
      (x)=>{
           var area=new Area(
           x.ID, x.NAME,x.DESCRITION,x.INSTITUTEID);          
        return area;
      }
    );
  }

}
