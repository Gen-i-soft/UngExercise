import 'dart:convert';

class SubCatigoryModel {
  final String name;
  SubCatigoryModel({
    this.name,
  });

  SubCatigoryModel copyWith({
    String name,
  }) {
    return SubCatigoryModel(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory SubCatigoryModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SubCatigoryModel(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCatigoryModel.fromJson(String source) => SubCatigoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'SubCatigoryModel(name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SubCatigoryModel &&
      o.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
