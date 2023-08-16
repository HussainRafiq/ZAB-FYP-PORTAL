import Joi from "joi";

export default {
  groupInvitationSchema: Joi.object().keys({
    user_id: Joi.string().required()
  }),
};
