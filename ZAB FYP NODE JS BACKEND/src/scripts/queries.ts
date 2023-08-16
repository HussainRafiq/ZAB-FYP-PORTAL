export default {
    filterUser:
        `SELECT * FROM users
         WHERE ID = COALESCE(:ID,ID) AND 
         EMAIL = COALESCE(:EMAIL,EMAIL) AND 
         USERNAME = COALESCE(:USERNAME,USERNAME) AND 
         (:FIRST_NAME IS NULL OR FIRST_NAME LIKE '%:FIRST_NAME%') AND 
         (:LAST_NAME IS NULL OR LAST_NAME LIKE '%:LAST_NAME%') AND 
         IS_LOCKED = COALESCE(:IS_LOCKED,IS_LOCKED) AND 
         IS_VERIFIED = COALESCE(:IS_VERIFIED,IS_VERIFIED) AND 
         (:PHONE_NUMBER IS NULL OR PHONE_NUMBER LIKE '%:PHONE_NUMBER%') AND 
         ROLE = COALESCE(:ROLE,ROLE) AND 
         STATUS = COALESCE(:STATUS,STATUS) AND 
         (:LOGIN_NAME IS NULL OR USERNAME = :LOGIN_NAME OR EMAIL = :LOGIN_NAME OR PHONE_NUMBER = :LOGIN_NAME) AND 
         (:SEARCH_STRING IS NULL OR CONCAT(USERNAME,' ',EMAIL,' ',PHONE_NUMBER) LIKE '%:SEARCH_STRING%') AND
         IS_DELETED=0 AND
         INSTITUTEID = COALESCE(:INSTITUTEID,INSTITUTEID) ;`,
    filterAdvisor:
        `SELECT u.ID,u.FIRST_NAME,u.LAST_NAME,u.EMAIL,u.EXTRA_PROPERTIES,u.PROFILE_PIC,a.ID AREA_ID,a.NAME AREA_NAME,a.DESCRIPTION AREA_DESCRIPTION
        FROM users_areas AS ua 
        JOIN areas AS a ON a.ID=ua.AREA_ID AND a.IS_DELETED=0 AND a.INSTITUTEID=ua.INSTITUTEID 
        JOIN users AS u ON u.ROLE='Advisor' AND u.ID=ua.USER_ID AND a.IS_DELETED=0 AND u.INSTITUTEID=ua.INSTITUTEID 
        WHERE ua.IS_DELETED=0 AND
        (:FIRST_NAME IS NULL OR FIRST_NAME LIKE '%:FIRST_NAME%') AND 
        (:LAST_NAME IS NULL OR LAST_NAME LIKE '%:LAST_NAME%') AND         
        ua.INSTITUTEID = COALESCE(:INSTITUTEID,ua.INSTITUTEID) `,
    filterArea:
        `SELECT * FROM areas
         WHERE ID = COALESCE(:ID,ID) AND 
         (:NAME IS NULL OR NAME LIKE :NAME) AND
         IS_DELETED=0 AND
         INSTITUTEID = COALESCE(:INSTITUTEID,INSTITUTEID) ;`,
    inviteGroupStudents:
        `SELECT u.*,gi.ID AS GROUP_INVITATION_ID,(gi.ID IS NOT NULL) IS_SENDED,
        gi.IS_ACCEPTED ,gi.SENDED_AT AS SENDED_REQUEST_AT 
        FROM users u 
        LEFT JOIN group_invitation gi ON u.ID=gi.RECEIVER_USER_ID AND gi.SENDER_USER_ID=:USER_ID AND gi.IS_DELETED=0 
        LEFT JOIN group_members gm ON gm.MEMBER_USER_ID=u.ID 
        WHERE u.ROLE='Student' AND u.ID<>:USER_ID AND gm.ID IS NULL AND         
        u.INSTITUTEID = COALESCE(:INSTITUTEID,u.INSTITUTEID)`,
    groupStudents:
        `SELECT u.ID As STUDENTID,u.*,g.*
        FROM users u 
        JOIN group_members gm ON gm.MEMBER_USER_ID=u.ID AND gm.INSTITUTEID=u.INSTITUTEID
        JOIN groups g ON g.ID=gm.GROUP_ID AND g.INSTITUTEID=gm.INSTITUTEID
        WHERE u.ROLE='Student'
        AND gm.GROUP_ID=(SELECT gm.GROUP_ID FROM group_members gm WHERE gm.MEMBER_USER_ID=:USER_ID ) 
        AND u.IS_DELETED=0 AND g.ISDELETED=0  AND gm.ISDELETED=0 AND         
        u.INSTITUTEID = COALESCE(:INSTITUTEID,u.INSTITUTEID)`,
    insertGroupInvitation:
        `INSERT INTO group_invitation
         (ID, SENDER_USER_ID, RECEIVER_USER_ID, IS_ACCEPTED, SENDED_AT, INSTITUTEID) 
         VALUES (NULL, :SENDER_USER_ID, :RECEIVER_USER_ID, 0, NOW(), :INSTITUTEID);`,
    invitedStudents:
        `SELECT u.*,gi.ID AS GROUP_INVITATION_ID,(gi.ID IS NOT NULL) IS_SENDED,
        gi.IS_ACCEPTED ,gi.SENDED_AT AS SENDED_REQUEST_AT 
        FROM users u 
        JOIN group_invitation gi ON u.ID=gi.RECEIVER_USER_ID AND gi.SENDER_USER_ID=:USER_ID
        WHERE u.ROLE='Student' AND u.ID<>:USER_ID AND gi.ID IS NOT NULL AND gi.IS_DELETED=0 AND      
        u.INSTITUTEID = COALESCE(:INSTITUTEID,u.INSTITUTEID)`,
    getSettings:
        `SELECT * From setting
        Where INSTITUTEID = COALESCE(:INSTITUTEID,INSTITUTEID)`,
    getInvitationByID:
        `SELECT * FROM group_invitation WHERE ID=:ID AND INSTITUTEID=COALESCE(:INSTITUTEID,INSTITUTEID)`,
    createGroup:
        `INSERT INTO groups (ID, IS_FINALIZED, INSTITUTEID, ISDELETED) VALUES (NULL, 0, :INSTITUTEID, '0')`,
    addGroupMember:
        `INSERT INTO group_members (ID, GROUP_ID, MEMBER_USER_ID, GROUP_INVITATION_ID, CREATED_AT, CREATED_BY, INSTITUTEID, ISDELETED) VALUES (NULL, :GROUPID, :USERID, :GROUPINVITATIONID, NOW(), :CREATEDBY, :INSTITUTEID, b'0')`,
    getInvitations:
        `SELECT u.*,gi.ID AS GROUP_INVITATION_ID,
        gi.IS_ACCEPTED ,gi.SENDED_AT AS SENDED_REQUEST_AT 
        FROM users u 
        JOIN group_invitation gi ON u.ID=gi.SENDER_USER_ID AND gi.RECEIVER_USER_ID=:USERID AND gi.IS_DELETED=0
        WHERE u.ROLE='Student' AND gi.ID IS NOT NULL AND         
        u.INSTITUTEID = COALESCE(:INSTITUTEID,u.INSTITUTEID);`,
    updateInvitation:
        `UPDATE group_invitation SET IS_ACCEPTED=:IS_ACCEPTED
        WHERE ID=:ID AND         
        INSTITUTEID = COALESCE(:INSTITUTEID,INSTITUTEID);`,
    updateGroup:
        `update groups set IS_FINALIZED=:ISFINALIZED WHERE ID=:ID AND INSTITUTEID=:INSTITUTEID`,
    createPurposal:
        `INSERT INTO purposals (TITLE, GROUP_ID, DESCRIPTION, CREATED_AT, CREATED_BY, INSTITUTEID, IS_DELETED) VALUES (:TITLE, :GROUP_ID, :DESCRIPTION,  NOW(), :CREATED_BY, :INSTITUTEID, 0);`,
    updatePurposal:
        `UPDATE purposals 
        SET TITLE = COALESCE(:title, TITLE), 
            GROUP_ID = COALESCE(:group_id, GROUP_ID), 
            DESCRIPTION = COALESCE(:description, DESCRIPTION), 
            UPDATED_AT = COALESCE(:updated_at, UPDATED_AT), 
            UPDATED_BY = COALESCE(:updated_by, UPDATED_BY)
        WHERE ID = :id AND INSTITUTEID = :institute_id AND IS_DELETED = 0`,
    deletePurposal:
            `UPDATE purposals
            SET IS_DELETED = 1,
            WHERE ID = :id AND INSTITUTEID = :institute_id AND IS_DELETED = 0`,
    getPurposals:
            `SELECT p.*, sp.ID SendProposalID, sp.AdvisorID, sp.Status, sp.SendedAt FROM purposals p
            LEFT join send_proposal sp on sp.ProposalID=p.ID and sp.IS_DELETED=0 and sp.INSTITUTEID=p.INSTITUTEID
            WHERE p.INSTITUTEID = :institute_id AND p.GROUP_ID = :GROUP_ID AND p.IS_DELETED = 0`,            
    getPurposalsByAdvisor:
            `SELECT p.*, sp.ID SendProposalID, sp.AdvisorID, sp.Status, sp.SendedAt FROM purposals p
            LEFT join send_proposal sp on sp.ProposalID=p.ID and sp.IS_DELETED=0 and sp.INSTITUTEID=p.INSTITUTEID
            WHERE p.INSTITUTEID = :institute_id AND sp.AdvisorID = :AdvisorID AND p.IS_DELETED = 0`,
    getPurposalByID:
            `SELECT p.*, sp.ID SendProposalID, sp.AdvisorID, sp.Status, sp.SendedAt FROM purposals p
            LEFT join send_proposal sp on sp.ProposalID=p.ID and sp.IS_DELETED=0 and sp.INSTITUTEID=p.INSTITUTEID 
            WHERE p.INSTITUTEID = :institute_id AND p.ID = :ID AND p.IS_DELETED = 0`,
    insertSendProposal:
            `INSERT INTO send_proposal
            (ProposalID,AdvisorID,SendedAt,Status,Is_Deleted,INSTITUTEID)
            values (:proposalID, :AdvisorID, NOW(), 'pending', 0, :INSTITUTEID)`,
    getPurposalComments:
            `SELECT * FROM proposal_comments
            WHERE INSTITUTEID = :institute_id AND PROPOSALID = :PROPOSAL_ID AND ISDELETED = 0`,
    getPurposalsByAdvisorID:
            `SELECT p.*, sp.ID SendProposalID, sp.AdvisorID, sp.Status, sp.SendedAt FROM purposals p
             join send_proposal sp on sp.ProposalID=p.ID and sp.IS_DELETED=0 and sp.INSTITUTEID=p.INSTITUTEID
            WHERE p.INSTITUTEID = :institute_id AND sp.AdvisorID = :ADVISOR_ID AND p.IS_DELETED = 0`,  
    insertPurposalComments:
            `Insert into proposal_comments (PROPOSALID, COMMENT, SENDEDAT, ADVISORID, ISINTERESTED, INSTITUTEID, ISDELETED)
            VALUES (:PROPOSALID, :COMMENT, NOW(), :ADVISORID, :ISINTERESTED, :INSTITUTEID, 0)`      
        
}