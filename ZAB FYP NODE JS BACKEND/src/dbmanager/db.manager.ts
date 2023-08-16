import mysql from "mysql2/promise";
import dbconfig from "../config/db.config";

export default class dbmanager {
	constructor() {}

	public async executeQuery(
		query: string,
		parameters: {},
		executeWithTranscation: boolean = false
	): Promise<{ rows: any; fields: any }> {
		try{
		let conn = await mysql.createConnection(dbconfig);

		await conn.connect();
		executeWithTranscation && (await conn.beginTransaction());
		try {
			let [rows, fields] = await conn.execute(query, parameters);
			return { rows, fields };
		} catch (error) {
			executeWithTranscation && (await conn.rollback());
			console.log(error);
		}
		executeWithTranscation && (await conn.commit());
		conn.end();
		return { rows: null, fields: null };
	}catch(ex){
		console.warn(ex);
		throw ex;
	}
	}
}
