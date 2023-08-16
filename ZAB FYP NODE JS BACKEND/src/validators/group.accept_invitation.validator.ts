import Joi from "joi";

export default {
  groupAcceptInvitationSchema: Joi.object().keys({
    invitation_id: Joi.string().required()
  }),
};
