export default class CurrentInstitute {
  constructor() {
  }
  public static get instance() {
    return new CurrentInstitute();
  }
  async get(url : string | null=null): Promise<string> {        
    return "szabist";
  }

}
