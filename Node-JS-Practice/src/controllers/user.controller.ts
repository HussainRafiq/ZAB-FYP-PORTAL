import joi from "joi";
import { Request, Response } from "express";
import AddUserModel from "../viewmodels/request/login.user.model";
import UserService from "../services/user.service";
import UserSchemas from "../validators/user.validator";
const bcrypt = require("bcrypt");
var jwt = require("jsonwebtoken");

import appConfig from "../config/app.config";
import UserResponseModel from "../viewmodels/response/user-response-model";
import SuccessResponseModel from "../viewmodels/response/succes_response_model";
import ErrorResponseModel from "../viewmodels/response/error_response_model";
import ErrorMessages from "../utils/error_messages";
export default class UserController {
  public userService: UserService;

  public static get instance(): UserController {
    return new UserController();
  }

  private constructor() {
    this.userService = UserService.instance;
  }

  public loginUser = async (req: Request, resp: Response) => {
    const validation = UserSchemas.loginUserSchema.validate(req.body);

    if (validation.error) {
      let errorDetails = validation.error.details.map((x) => x.message);
      resp.status(400).send(errorDetails);
      return;
    }
    try {
      let credential = AddUserModel.fromReqBody(req.body);

      let users = await this.userService.fetchUsers(null, null, null, null, null, null, null, null, null, null, credential.username, null);

      if (!users || users.length == 0) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LOGIN_FAILED_CODE));
      }
      var user = users[0];
      const passwordCompare = await bcrypt.compare(credential.password, user.PASSWORD);
      //if password not matches
      if (!passwordCompare) {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LOGIN_FAILED_CODE));
      }

      //if password not matches
      if (user.STATUS=="INACTIVE") {
        return resp
          .status(400)
          .json(new ErrorResponseModel(ErrorMessages.LOGIN_FAILED_ACCOUNT_INACTIVE_CODE));
      }
      
      //if password matches
      const data = {
        user: {
          id: user.ID,
          role: user.ROLE,
          instituteID: user.INSTITUTEID
        },
      };
      var JWT_SECRET = appConfig.jwtSecretKey;
      const authToken = jwt.sign(data, JWT_SECRET);
      resp.json(
        new SuccessResponseModel(
        {
        user: new UserResponseModel(user.ID!, user.FIRST_NAME!, user.LAST_NAME! ,user.EMAIL! ,user.PHONE_NUMBER! ,user.STATUS!,
          user.ROLE!, user.IS_VERIFIED! ,user.IS_LOCKED! ,user.EXTRA_PROPERTIES!,user.INSTITUTEID!),
        token: authToken
      })); //JS6 FEATURE (authToken : authToken)
    } catch ( error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };

  public Advisors = async (req: Request, resp: Response) => {
    try {

      let advisors = await this.userService.fetchAdvisors();
      // console.log(advisors);
      resp.json(
        new SuccessResponseModel(advisors));
    } catch ( error) {
      console.error(error);
      resp.status(500).json("Internel Server error.");
    }
  };








}
