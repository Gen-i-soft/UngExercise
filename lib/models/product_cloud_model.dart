import 'dart:convert';

class ProductCloudModel {
  final String name;
  final String urlImage;
  ProductCloudModel({
    this.name,
    this.urlImage,
  });

  ProductCloudModel copyWith({
    String name,
    String urlImage,
  }) {
    return ProductCloudModel(
      name: name ?? this.name,
      urlImage: urlImage ?? this.urlImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'urlImage': urlImage,
    };
  }

  factory ProductCloudModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductCloudModel(
      name: map['name'],
      urlImage: map['urlImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCloudModel.fromJson(String source) => ProductCloudModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCloudModel(name: $name, urlImage: $urlImage)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductCloudModel &&
      o.name == name &&
      o.urlImage == urlImage;
  }

  @override
  int get hashCode => name.hashCode ^ urlImage.hashCode;
}
