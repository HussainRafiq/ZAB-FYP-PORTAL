import Product from "../models/product.model";
import Dbmanager from "../dbmanager/db.manager";
import Dbfactory from "../dbmanager/db.factory";
export default class ProductService {
  private dbmanager: Dbmanager;

  public static get instance(): ProductService {
    return new ProductService();
  }

  constructor() {
    this.dbmanager = Dbfactory.instance;
  }
  createProduct(product: Product): Product {
    return product;
  }

  fetchProduct(productid: number): Product {
    let products = [
      { id: 1, name: "coco", qty: 123, price: 1.0 },
      { id: 2, name: "wheatables", qty: 123, price: 1.0 },
      { id: 3, name: "slice", qty: 123, price: 1.0 },
    ];
    return products.filter((x) => x.id == productid)[0];
  }
  deleteProduct(productid: number): boolean {
    return true;
  }
}
