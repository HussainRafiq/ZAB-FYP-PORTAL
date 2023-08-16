import logger from "morgan";
import appConfig from "./config/app.config";
import express, { json } from "express";

import userRouter from "./router/user.router";
import productRouter from "./router/product.router";
import areaRouter from "./router/area.router";

import groupRouter from "./router/group.router";
import proposalRouter from "./router/proposal.router";

const routers = [userRouter, areaRouter, groupRouter, proposalRouter];

const app = express();

app.use(json());

app.use("/api", routers);

app.listen(appConfig.port, () => console.log(`listening on ${appConfig.port}`));

