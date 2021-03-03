import 'dart:convert';

class CategoryModel {
  final String name;

  final String itemcode;
  CategoryModel({
    this.name,
    this.itemcode,
  });

  CategoryModel copyWith({
    String name,
    String itemcode,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      itemcode: itemcode ?? this.itemcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemcode': itemcode,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CategoryModel(
      name: map['name'],
      itemcode: map['itemcode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(name: $name, itemcode: $itemcode)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CategoryModel &&
      o.name == name &&
      o.itemcode == itemcode;
  }

  @override
  int get hashCode => name.hashCode ^ itemcode.hashCode;
}
