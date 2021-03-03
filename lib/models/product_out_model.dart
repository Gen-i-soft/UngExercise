import 'dart:convert';

class ProductOutModel {
  String urlImage;
  String name;
  String categoryName;
  ProductOutModel({
    this.urlImage,
    this.name,
    this.categoryName,
  });

  ProductOutModel copyWith({
    String urlImage,
    String name,
    String categoryName,
  }) {
    return ProductOutModel(
      urlImage: urlImage ?? this.urlImage,
      name: name ?? this.name,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urlImage': urlImage,
      'name': name,
      'categoryName': categoryName,
    };
  }

  factory ProductOutModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductOutModel(
      urlImage: map['urlImage'],
      name: map['name'],
      categoryName: map['categoryName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOutModel.fromJson(String source) => ProductOutModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductOutModel(urlImage: $urlImage, name: $name, categoryName: $categoryName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductOutModel &&
      o.urlImage == urlImage &&
      o.name == name &&
      o.categoryName == categoryName;
  }

  @override
  int get hashCode => urlImage.hashCode ^ name.hashCode ^ categoryName.hashCode;
}
