import 'dart:convert';

class ProductTwoModel {
  String name;
  String urlImage;
  String itemCategory;
  String categoryName;
  ProductTwoModel({
    this.name,
    this.urlImage,
    this.itemCategory,
    this.categoryName,
  });

  ProductTwoModel copyWith({
    String name,
    String urlImage,
    String itemCategory,
    String categoryName,
  }) {
    return ProductTwoModel(
      name: name ?? this.name,
      urlImage: urlImage ?? this.urlImage,
      itemCategory: itemCategory ?? this.itemCategory,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'urlImage': urlImage,
      'itemCategory': itemCategory,
      'categoryName': categoryName,
    };
  }

  factory ProductTwoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductTwoModel(
      name: map['name'],
      urlImage: map['urlImage'],
      itemCategory: map['itemCategory'],
      categoryName: map['categoryName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductTwoModel.fromJson(String source) => ProductTwoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(name: $name, urlImage: $urlImage, itemCategory: $itemCategory, categoryName: $categoryName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductTwoModel &&
      o.name == name &&
      o.urlImage == urlImage &&
      o.itemCategory == itemCategory &&
      o.categoryName == categoryName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      urlImage.hashCode ^
      itemCategory.hashCode ^
      categoryName.hashCode;
  }
}
