import 'dart:convert';

class TypeUserModel {
  final String typeUser;
  TypeUserModel({
    this.typeUser,
  });

  TypeUserModel copyWith({
    String typeUser,
  }) {
    return TypeUserModel(
      typeUser: typeUser ?? this.typeUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeUser': typeUser,
    };
  }

  factory TypeUserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TypeUserModel(
      typeUser: map['typeUser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeUserModel.fromJson(String source) => TypeUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'TypeUserModel(typeUser: $typeUser)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TypeUserModel &&
      o.typeUser == typeUser;
  }

  @override
  int get hashCode => typeUser.hashCode;
}
