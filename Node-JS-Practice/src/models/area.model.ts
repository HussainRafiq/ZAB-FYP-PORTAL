export default class Area {
  public ID: string;
  public NAME: string;
  public DESCRITION: string;
  public INSTITUTEID: string;
  constructor(ID: string, NAME: string, DESCRITION: string,
    INSTITUTEID: string) {
    this.ID=ID;
    this.NAME=NAME;
    this.DESCRITION=DESCRITION;
    this.INSTITUTEID=INSTITUTEID
  }

}
