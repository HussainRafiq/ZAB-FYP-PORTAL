import {Express, Request, Response, NextFunction} from 'express';
import appConfig from '../config/app.config';
import ErrorMessages from '../utils/error_messages';
import ErrorResponseModel from '../viewmodels/response/error_response_model';
const jwt = require("jsonwebtoken");


const verifyToken = (allowedAccessTypes: string[]) => (req: Request, res: Response, next: NextFunction) => {
  const token =
  req.body.token || req.query.token || req.headers["x-access-token"];
  console.log("token");
  console.log(token);
  
  console.log("req1");
  console.log(req.path);
  if (!token) {
    return res.status(403).send(new ErrorResponseModel(ErrorMessages.getErrorMessage(ErrorMessages.INVALID_TOKEN_CODE)));
  }
  try {
    const decoded = jwt.verify(token, appConfig.jwtSecretKey);
    console.log("decoded");
    console.log(decoded);
    if(!decoded || !decoded.user || !decoded.user.role || !allowedAccessTypes.includes(decoded.user.role.toLowerCase())){      
    return res.status(401).send(new ErrorResponseModel(ErrorMessages.getErrorMessage(ErrorMessages.AUTHENTICATION_FAIL_CODE)));
    }
    (<any>req).currentUser =decoded.user;
  } catch (err) {
    return res.status(401).send(new ErrorResponseModel(ErrorMessages.getErrorMessage(ErrorMessages.AUTHENTICATION_FAIL_CODE)));
  }

  return next();
};

module.exports = verifyToken;