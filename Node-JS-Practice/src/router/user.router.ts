import express from "express";
import UserController from "../controllers/user.controller";

const router = express.Router();

let userController = UserController.instance;

router.post("/user/login", userController.loginUser);
router.get("/user/advisor", userController.Advisors);

export default router;
