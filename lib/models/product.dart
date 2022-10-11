class Product{
  int? id;
  String? name;
  double? price;
  int? stock;
  String? currency;
  int? quantitySold;

  Product(this.id, this.name,this.currency ,this.price,this.stock,this.quantitySold);

  Product.fromJson(Map json) {
    id = int.parse(json["Id"].toString());
    name = json["Urun_adi"];
    currency = json["ParaBirimi"];
    price = double.parse(json["Fiyati"].toString()) ;
    stock = int.parse(json["Stok"].toString());
    quantitySold = int.parse(json["SatilanMiktar"].toString());
  }

  Map toJson() {
    return {
      "Id": id,
      "Urun_adi": name,
      "ParaBirimi": currency,
      "Fiyati": price,
      "Stok": stock,
      "SatilanMiktar": quantitySold,
    };
  }
}