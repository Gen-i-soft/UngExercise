import 'dart:convert';

class CatigoryModel {
  final String name;
  final String detail;
  CatigoryModel({
    this.name,
    this.detail,
  });

  CatigoryModel copyWith({
    String name,
    String detail,
  }) {
    return CatigoryModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
    };
  }

  factory CatigoryModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CatigoryModel(
      name: map['name'],
      detail: map['detail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CatigoryModel.fromJson(String source) => CatigoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CatigoryModel(name: $name, detail: $detail)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CatigoryModel &&
      o.name == name &&
      o.detail == detail;
  }

  @override
  int get hashCode => name.hashCode ^ detail.hashCode;
}
