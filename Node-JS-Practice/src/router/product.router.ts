import express from "express";
import ProductController from "../controllers/product.controller";
const auth = require("../middleware/auth");
const router = express.Router();

let productController = ProductController.instance;



router.post("/product", productController.addProduct);
router.get("/product/:id",auth, productController.getProductById);
router.delete("/product", productController.removeProduct);

export default router;
