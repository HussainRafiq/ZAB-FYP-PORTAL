import Joi from "joi";

export default {
  loginUserSchema: Joi.object().keys({
    username: Joi.string().required(),
    password: Joi.string().required(),
  }),
};
