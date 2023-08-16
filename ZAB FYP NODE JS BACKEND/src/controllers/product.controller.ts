import joi from "joi";
import ProductService from "../services/product.service";
import { Request, Response } from "express";

export default class ProductController {
  private productService: ProductService;

  public static get instance(): ProductController {
    return new ProductController();
  }

  private constructor() {
    this.productService = ProductService.instance;
  }

  public addProduct = (req: Request, resp: Response) => {
    let product = {
      id: req.body.id ?? null,
      name: req.body.name,
      qty: req.body.quantity,
      price: req.body.price,
    };
    var createdProduct = this.productService.createProduct(product);
    resp.status(201).send(createdProduct);
  };

  public getProductById = (req: Request, resp: Response) => {
    let id = parseInt(req.params.id);
    let foundProduct = this.productService.fetchProduct(id);
    if (!foundProduct) resp.status(404).send();
    resp.status(200).send(foundProduct);
  };

  public removeProduct = (req: Request, resp: Response) => {
    let productId = parseInt(req.params.id);
    if (!this.productService.deleteProduct(productId)) {
      resp.status(400);
      return;
    }
    resp.status(200);
  };
}
