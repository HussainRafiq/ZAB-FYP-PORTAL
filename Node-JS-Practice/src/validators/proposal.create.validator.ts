import Joi from "joi";

export default {
  proposalCreateSchema: Joi.object().keys({
    title: Joi.string().required(),
    description: Joi.string().required(),
  }),
};
