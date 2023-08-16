export default class product{
    public id: number;
    public name: string;
    public qty: number;
    public price: number;

    constructor(id: number, name: string, qty: number, price: number){
        this.id = id;
        this.name = name;
        this.price = price;
        this.qty = qty;
    }
}