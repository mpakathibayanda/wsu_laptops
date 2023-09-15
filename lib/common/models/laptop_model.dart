// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LaptopModel {
  String laptopName;
  String laptopSerialNumber;
  LaptopModel({
    required this.laptopName,
    required this.laptopSerialNumber,
  });

  LaptopModel copyWith({
    String? laptopName,
    String? laptopSerialNumber,
  }) {
    return LaptopModel(
      laptopName: laptopName ?? this.laptopName,
      laptopSerialNumber: laptopSerialNumber ?? this.laptopSerialNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'laptopName': laptopName,
      'laptopSerialNumber': laptopSerialNumber,
    };
  }

  factory LaptopModel.fromMap(Map<String, dynamic> map) {
    return LaptopModel(
      laptopName: map['laptopName'] as String,
      laptopSerialNumber: map['laptopSerialNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LaptopModel.fromJson(String source) =>
      LaptopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LaptopModel(laptopName: $laptopName, laptopSerialNumber: $laptopSerialNumber)';

  @override
  bool operator ==(covariant LaptopModel other) {
    if (identical(this, other)) return true;

    return other.laptopName == laptopName &&
        other.laptopSerialNumber == laptopSerialNumber;
  }

  @override
  int get hashCode => laptopName.hashCode ^ laptopSerialNumber.hashCode;
}
