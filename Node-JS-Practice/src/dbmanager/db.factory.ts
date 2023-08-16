import dbmanager from './db.manager'
export default  class dbfactory {

    public static get instance(){
        return new dbmanager();
    }
}