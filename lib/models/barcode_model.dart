import 'dart:convert';

class BarcodeModel {
  final String barcode;
  final double price;
  final String unit_code;
  BarcodeModel({
    this.barcode,
    this.price,
    this.unit_code,
  });

  BarcodeModel copyWith({
    String barcode,
    double price,
    String unit_code,
  }) {
    return BarcodeModel(
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      unit_code: unit_code ?? this.unit_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'price': price,
      'unit_code': unit_code,
    };
  }

  factory BarcodeModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return BarcodeModel(
      barcode: map['barcode'],
      price: map['price'],
      unit_code: map['unit_code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeModel.fromJson(String source) => BarcodeModel.fromMap(json.decode(source));

  @override
  String toString() => 'BarcodeModel(barcode: $barcode, price: $price, unit_code: $unit_code)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is BarcodeModel &&
      o.barcode == barcode &&
      o.price == price &&
      o.unit_code == unit_code;
  }

  @override
  int get hashCode => barcode.hashCode ^ price.hashCode ^ unit_code.hashCode;
}
