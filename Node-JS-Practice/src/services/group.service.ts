import User from "../models/user.model";
import Dbfactory from "../dbmanager/db.factory";
import Dbmanager from "../dbmanager/db.manager";
import queries from "../scripts/queries";
import CurrentInstitute from "../utils";
import GroupInvitation from "../models/group_invitation.model";
import Student from "../models/student.model";
import Group from "../models/group.model";
import { x } from "joi";

export default class GroupService {
  private dbmanager: Dbmanager;
  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  public static get instance() {
    return new GroupService();
  }
  async fetchGroupInvitedUser(
    userID: number | null = null): Promise<GroupInvitation[] | null> {
    var parameters = {
      USER_ID: userID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.inviteGroupStudents,
      parameters
    );
    let fetchedUser = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!fetchedUser.length) return [];

    return fetchedUser.map(
      (x) => {
        var user = new Student(
          x.ID, x.USERNAME, x.FIRST_NAME, x.LAST_NAME, x.EMAIL, x.PHONE_NUMBER, x.STATUS,
          x.ROLE, x.IS_VERIFIED, x.IS_LOCKED, x.EXTRA_PROPERTIES, x.INSTITUTEID);
        return new GroupInvitation(x.GROUP_INVITATION_ID,user, x.IS_SENDED, x.IS_ACCEPTED, x.SENDED_AT);
      }
    );
  }
  async fetchGroup(
    userID: number | null = null): Promise<Group | null> {
    var parameters = {
      USER_ID: userID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.groupStudents,
      parameters
    );
    let groups = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!groups.length) return null;
    var listGroups = <Group[]>[];
    groups.forEach(
      (obj, i, arr) => {
        var group = listGroups.find(x => x.ID == obj.ID);
        var user = new Student(
          obj.STUDENTID, obj.USERNAME, obj.FIRST_NAME, obj.LAST_NAME, obj.EMAIL, obj.PHONE_NUMBER, obj.STATUS,
          obj.ROLE, obj.IS_VERIFIED, obj.IS_LOCKED, obj.EXTRA_PROPERTIES, obj.INSTITUTEID);
        if (group && group.Students) {          
          group.Students.push(user);
        } else {
          listGroups.push(new Group(obj.ID, [user], obj.IS_FINALIZED));
        }
      }
    );

    return listGroups.length>0?listGroups[0]:null;
  }
  async fetchGroupInvited(
    userID: number | null = null): Promise<GroupInvitation[] | null> {
    var parameters = {
      USER_ID: userID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.invitedStudents,
      parameters
    );
    let fetchedUser = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!fetchedUser.length) return [];

    return fetchedUser.map(
      (x) => {
        var user = new Student(
          x.ID, x.USERNAME, x.FIRST_NAME, x.LAST_NAME, x.EMAIL, x.PHONE_NUMBER, x.STATUS,
          x.ROLE, x.IS_VERIFIED, x.IS_LOCKED, x.EXTRA_PROPERTIES, x.INSTITUTEID);
        return new GroupInvitation(x.GROUP_INVITATION_ID,user, x.IS_SENDED, x.IS_ACCEPTED, x.SENDED_AT);
      }
    );
  }

  async InviteUser(
    Sender_userID: string | null = null, Receiver_userID: string | null = null): Promise<boolean | null> {
    var parameters = {
      SENDER_USER_ID:Sender_userID,
      RECEIVER_USER_ID: Receiver_userID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.insertGroupInvitation,
      parameters
    );

   return table.rows.affectedRows>0;
  }

  async fetchInvitationByID(
    ID: number | null = null): Promise<GroupInvitation | null> {
    var parameters = {
      ID: ID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getInvitationByID,
      parameters
    );

    let invitations = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!invitations.length) return null;
    var mapInvitations=invitations.map(function(x){
      return new GroupInvitation(x.ID,undefined,true,x.IS_ACCEPTED,x.SENDED_AT,x.SENDER_USER_ID,x.RECEIVER_USER_ID)
    });

    return mapInvitations.length>0?mapInvitations[0]:null;
  }

  async insertGroup(): Promise<number | null> {
    var parameters = {
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.createGroup,
      parameters
    );
    return table.rows.insertId;
  }
  async insertGroupMember(
    GROUPID: number | null = null, USERID: number | null = null, GROUPINVITATIONID: number | null = null, CREATEDBY: number | null = null): Promise<number | null> {
    var parameters = {
      GROUPID: GROUPID,
      USERID : USERID, 
      GROUPINVITATIONID : GROUPINVITATIONID,
      CREATEDBY : CREATEDBY,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.addGroupMember,
      parameters
    );
    return table.rows.insertId;
  }
  async fetchInvitations(
    userID: number | null = null): Promise<GroupInvitation[] | null> {
    var parameters = {
      USERID: userID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getInvitations,
      parameters
    );
    let fetchedUser = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    if (!fetchedUser.length) return [];

    return fetchedUser.map(
      (x) => {
        var user = new Student(
          x.ID, x.USERNAME, x.FIRST_NAME, x.LAST_NAME, x.EMAIL, x.PHONE_NUMBER, x.STATUS,
          x.ROLE, x.IS_VERIFIED, x.IS_LOCKED, x.EXTRA_PROPERTIES, x.INSTITUTEID);
        return new GroupInvitation(x.GROUP_INVITATION_ID,user,true, x.IS_ACCEPTED, x.SENDED_AT);
      }
    );
  }
  async updateGroupInvitations(IsAccepted: Boolean,
    InvitationID: number | null = null): Promise<Boolean | null> {
    var parameters = {
      IS_ACCEPTED: IsAccepted?"1":"0",
      ID: InvitationID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.updateInvitation,
      parameters
    );
    
    return table.rows.affectedRows>0;
  }

  async updateGroup(IsFinalised: Boolean,ID: number): Promise<Boolean | null> {
    var parameters = {
      ISFINALIZED: IsFinalised,
      ID: ID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    console.log(parameters);
    var table = await this.dbmanager.executeQuery(
      queries.updateGroup,
      parameters
    );
    return table.rows.affectedRows>0;
  }

}
