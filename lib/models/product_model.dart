class ProductModel {
  String code;
  String name;
  List<Barcodes> barcodes;

  ProductModel({this.code, this.name, this.barcodes});

  ProductModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    if (json['barcodes'] != null) {
      barcodes = new List<Barcodes>();
      json['barcodes'].forEach((v) {
        barcodes.add(new Barcodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.barcodes != null) {
      data['barcodes'] = this.barcodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Barcodes {
  String barcode;
  double price;
  String icCode;
  String unitCode;
  int priceMember;

  Barcodes(
      {this.barcode, this.price, this.icCode, this.unitCode, this.priceMember});

  Barcodes.fromJson(Map<String, dynamic> json) {
    barcode = json['barcode'];
    // price = json['price'];
     var priceVar = json['price'];
    String priceStr = priceVar.toString();
    price = double.parse(priceStr);
    icCode = json['ic_code'];
    unitCode = json['unit_code'];
    priceMember = json['price_member'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['price'] = this.price;
    data['ic_code'] = this.icCode;
    data['unit_code'] = this.unitCode;
    data['price_member'] = this.priceMember;
    return data;
  }
}
