import express from "express";
import AreaController from "../controllers/area.controller";

const router = express.Router();

let areaController = AreaController.instance;

router.get("/area", areaController.Areas);

export default router;
