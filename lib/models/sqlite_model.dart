import 'dart:convert';

class SQLiteModel {
  final int id;
  final String code;
  final String name;
  final String barcodes;
  final String prices;
  final String units;
  final int amounts;
  final String subtotals;
  final String picturl;
  SQLiteModel({
    this.id,
    this.code,
    this.name,
    this.barcodes,
    this.prices,
    this.units,
    this.amounts,
    this.subtotals,
    this.picturl,
  });

  SQLiteModel copyWith({
    int id,
    String code,
    String name,
    String barcodes,
    String prices,
    String units,
    int amounts,
    String subtotals,
    String picturl,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      barcodes: barcodes ?? this.barcodes,
      prices: prices ?? this.prices,
      units: units ?? this.units,
      amounts: amounts ?? this.amounts,
      subtotals: subtotals ?? this.subtotals,
      picturl: picturl ?? this.picturl,
    );
  }

  Map<String, dynamic> toJsonzz() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_code'] = this.code;
    data['line_number'] = 0;
    data['is_permium'] = 0;
    data['unit_code'] = this.units;
    data['wh_code'] = 'CMI01';
    data['shelf_code'] = 'CMI420';
    data['qty'] = this.amounts;
    data['price'] = this.prices;
    data['price_exclude_vat'] = double.parse(this.prices)/1.07 ;
    data['discount_amount'] = 0 ;
    data['sum_amount'] = this.subtotals;
    data['vat_amount'] = double.parse(this.prices)-double.parse(this.prices)/1.07 ;
    data['tax_type'] = 0;
    data['vat_type'] = 1;
    data['sum_amount_exclude_vat'] = double.parse(this.prices)/1.07 ;


    data['name'] = this.name;
    data['barcode'] = this.barcodes;
    
   
    
    
    
    
    


    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'barcodes': barcodes,
      'prices': prices,
      'units': units,
      'amounts': amounts,
      'subtotals': subtotals,
      'picturl': picturl,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SQLiteModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      barcodes: map['barcodes'],
      prices: map['prices'],
      units: map['units'],
      amounts: map['amounts'],
      subtotals: map['subtotals'],
      picturl: map['picturl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel(id: $id, code: $code, name: $name, barcodes: $barcodes, prices: $prices, units: $units, amounts: $amounts, subtotals: $subtotals, picturl: $picturl)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SQLiteModel &&
        o.id == id &&
        o.code == code &&
        o.name == name &&
        o.barcodes == barcodes &&
        o.prices == prices &&
        o.units == units &&
        o.amounts == amounts &&
        o.subtotals == subtotals &&
        o.picturl == picturl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        barcodes.hashCode ^
        prices.hashCode ^
        units.hashCode ^
        amounts.hashCode ^
        subtotals.hashCode ^
        picturl.hashCode;
  }
}
