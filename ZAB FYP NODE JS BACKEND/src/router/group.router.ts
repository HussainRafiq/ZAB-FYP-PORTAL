import express from "express";
import GroupController from "../controllers/group.controller";

const auth = require("../middleware/auth");
const router = express.Router();

let groupController = GroupController.instance;

router.get("/group/student",auth(["student"]),groupController.GroupInvitedStudents );
router.get("/group",auth(["student"]),groupController.Group );
router.post("/group/invitation",auth(["student"]),groupController.sendGroupInvitation );
router.post("/group/accept",auth(["student"]),groupController.AcceptInvitationLink );
router.get("/group/invitation",auth(["student"]),groupController.getInvitations );
router.post("/group/finalize",auth(["student"]),groupController.FinalizedGroup );
export default router;
