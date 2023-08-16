import joi from "joi";
import { Request, Response } from "express";
import AreaService from "../services/area.service";
import SuccessResponseModel from "../viewmodels/response/succes_response_model";
export default class AreaController {
  public areaService: AreaService;

  public static get instance(): AreaController {
    return new AreaController();
  }

  private constructor() {
    this.areaService = AreaService.instance;
  }

  public Areas = async (req: Request, resp: Response) => {
    try {
      let areas = await this.areaService.fetchAreas(null,req.query.name?req.query.name+"":null);
      resp.json(
        new SuccessResponseModel(areas)); //JS6 FEATURE (authToken : authToken)
    } catch ( error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };









}
