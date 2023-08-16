import Dbfactory from "../dbmanager/db.factory";
import Dbmanager from "../dbmanager/db.manager";
import Proposal from "../models/proposal.model";
import queries from "../scripts/queries";
import CurrentInstitute from "../utils";

export default class ProposalService {
  private dbmanager: Dbmanager;
  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  public static get instance() {
    return new ProposalService();
  }
  
  async insertProposal(TITLE?: string,
    GROUP_ID?: String,
    DESCRIPTION?: String,
    CREATED_BY?: String): Promise<number | null> {
    var parameters = {
      TITLE: TITLE,
      GROUP_ID: GROUP_ID,
      DESCRIPTION: DESCRIPTION,
      CREATED_BY: CREATED_BY,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.createPurposal,
      parameters
    );
    return table.rows.insertId;
  }
  
  async fetchProposalByID(
    ID: number | null = null): Promise<Proposal | null> {
    var parameters = {
      ID: ID,
      institute_id: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getPurposalByID,
      parameters
    );
    let proposals = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    
    if (!proposals.length) return null;
    var mapInvitations=proposals.map(function(x){
      return new Proposal(x.ID,x.TITLE, x.GROUP_ID,x.DESCRIPTION,x.CREATED_AT,x.CREATED_BY,undefined,undefined,x.INSTITUTEID);
    });

    return mapInvitations.length>0?mapInvitations[0]:null;
  }

  async fetchProposals(
    GROUP_ID: String | null = null): Promise<Proposal[] | null> {
    var parameters = {
      GROUP_ID: GROUP_ID,
      institute_id: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getPurposals,
      parameters
    );
    let proposals = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    
    if (!proposals.length) return [];
    var proposalList:any={};
    var mapProposals=proposals.map(function(x){
      if(!proposalList[x.ID])
      {
        proposalList[x.ID]=new Proposal(x.ID,x.TITLE, x.GROUP_ID,x.DESCRIPTION,x.CREATED_AT,x.CREATED_BY,undefined,undefined,x.INSTITUTEID);
        proposalList[x.ID].SendProposals=[];
      }
      if(x.SendProposalID && x.AdvisorID, x.Status, x.SendedAt)
      {
        proposalList[x.ID].SendProposals.push({
          SendProposalID:x.SendProposalID, AdvisorID:x.AdvisorID, Status:x.Status, SendedAt:x.SendedAt
        });
      }
      
      return proposalList[x.ID];
    });
    return Object.values(proposalList);
  }
  async fetchProposalsByAdvisor(
    ADVISOR_ID: String | null = null): Promise<Proposal[] | null> {
    var parameters = {
      ADVISOR_ID: ADVISOR_ID,
      institute_id: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getPurposalsByAdvisorID,
      parameters
    );
    let proposals = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    
    if (!proposals.length) return [];
    var proposalList:any={};
    var mapProposals=proposals.map(function(x){
      if(!proposalList[x.ID])
      {
        proposalList[x.ID]=new Proposal(x.ID,x.TITLE, x.GROUP_ID,x.DESCRIPTION,x.CREATED_AT,x.CREATED_BY,undefined,undefined,x.INSTITUTEID);
        proposalList[x.ID].SendProposals=[];
      }
      if(x.SendProposalID && x.AdvisorID, x.Status, x.SendedAt)
      {
        proposalList[x.ID].SendProposals.push({
          SendProposalID:x.SendProposalID, AdvisorID:x.AdvisorID, Status:x.Status, SendedAt:x.SendedAt
        });
      }
      
      return proposalList[x.ID];
    });
    return Object.values(proposalList);
  }
  
  async fetchProposalSComments(
    PROPOSAL_ID: String | null = null): Promise<Proposal[] | null> {
    var parameters = {
      PROPOSAL_ID: PROPOSAL_ID,
      institute_id: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.getPurposalComments,
      parameters
    );
    let proposalComments = Array.isArray(table.rows) ? Array.from(table.rows) : [];
    
    if (!proposalComments.length) return [];
    var mapProposalComments=proposalComments.map(function(x){
      
      return {
        ID:x.ID,
        PROPOSAL_ID:x.PROPOSALID,
        COMMENT:x.COMMENT,
        SENDEDAT:x.SENDEDAT,
        ADVISORID:x.ADVISORID,
        ISINTERESTED:x.ISINTERESTED
      };
    });
    return mapProposalComments;
  }

  async insertSendProposal(ProposalID?: String,
    AdvisorID?: String): Promise<number | null> {
    var parameters = {
      proposalID: ProposalID,
      AdvisorID:AdvisorID,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.insertSendProposal,
      parameters
    );
    return table.rows.insertId;
  }
  async insertProposalComment(PROPOSAL_ID?: string,
    COMMENT?: String,
    ADVISORID?: String,
    ISINTERESTED?: String): Promise<number | null> {
    var parameters = {
      PROPOSALID: PROPOSAL_ID,
      COMMENT: COMMENT,
      ADVISORID: ADVISORID,
      ISINTERESTED: ISINTERESTED,
      INSTITUTEID: await CurrentInstitute.instance.get("")
    };
    var table = await this.dbmanager.executeQuery(
      queries.insertPurposalComments,
      parameters
    );
    return table.rows.insertId;
  }

}
