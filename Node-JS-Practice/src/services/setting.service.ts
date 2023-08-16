import Dbfactory from "../dbmanager/db.factory";
import Dbmanager from "../dbmanager/db.manager";
import queries from "../scripts/queries";
import CurrentInstitute from "../utils";

export default class SettingService {
  private dbmanager: Dbmanager;
  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  public static get instance() {
    return new SettingService();
  }
  async fetchSetting(): Promise<{[id: string]: string;}> {    
    var parameters = {     
      INSTITUTEID:await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getSettings,
      parameters
    );
    let settings = Array.isArray(table.rows) ? Array.from(table.rows) : [];
   
    if (!settings.length) return {};
    
    var settingsMap: { [id: string]: string; }  = {};
    
    settings.forEach(function(val,ind,arr){
      
      settingsMap[val.SETTING_KEY]=val.SETTING_VALUE;
      
    });
    
     
    return settingsMap;
  }
}
