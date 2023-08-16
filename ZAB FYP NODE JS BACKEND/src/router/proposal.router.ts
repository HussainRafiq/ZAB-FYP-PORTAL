import express from "express";
import ProposalController from "../controllers/proposal.controller";

const auth = require("../middleware/auth");
const router = express.Router();

let proposalController = ProposalController.instance;

router.post("/proposal",auth(["student"]),proposalController.createProposal );
router.get("/proposal",auth(["student","advisor"]),proposalController.getProposals );
router.post("/proposal/send",auth(["student"]),proposalController.sendProposal );
router.get("/proposal/comment",auth(["student","advisor"]),proposalController.getProposalComments );
router.post("/proposal/comment",auth(["advisor"]),proposalController.insertProposalComment );


export default router;
