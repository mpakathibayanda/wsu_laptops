// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LaptopModel {
  String brandName;
  String? price;
  String? warrant;
  String? ramSize;
  String? storage;
  String? laptopSerialNumber;
  LaptopModel({
    required this.brandName,
    this.price,
    this.warrant,
    this.ramSize,
    this.storage,
    this.laptopSerialNumber,
  });

  LaptopModel copyWith({
    String? laptopName,
    String? price,
    String? warrant,
    String? ramSize,
    String? storage,
    String? laptopSerialNumber,
  }) {
    return LaptopModel(
      brandName: laptopName ?? brandName,
      price: price ?? this.price,
      warrant: warrant ?? this.warrant,
      ramSize: ramSize ?? this.ramSize,
      storage: storage ?? this.storage,
      laptopSerialNumber: laptopSerialNumber ?? this.laptopSerialNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brandName': brandName,
      'price': price,
      'warrant': warrant,
      'ramSize': ramSize,
      'storage': storage,
      'laptopSerialNumber': laptopSerialNumber,
    };
  }

  Map<String, dynamic> toAppwrite() {
    return <String, dynamic>{
      'brandName': brandName,
      'price': price,
      'warrant': warrant,
      'ramSize': ramSize,
      'storage': storage,
      'serialNumber': laptopSerialNumber,
    };
  }

  factory LaptopModel.fromMap(Map<String, dynamic> map) {
    return LaptopModel(
      brandName: map['brandName'] as String,
      price: map['price'] != null ? map['price'] as String : null,
      warrant: map['warrant'] != null ? map['warrant'] as String : null,
      ramSize: map['ramSize'] != null ? map['ramSize'] as String : null,
      storage: map['storage'] != null ? map['storage'] as String : null,
      laptopSerialNumber: map['laptopSerialNumber'] != null
          ? map['laptopSerialNumber'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LaptopModel.fromJson(String source) =>
      LaptopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LaptopModel(brandName: $brandName, price: $price, warrant: $warrant, ramSize: $ramSize, storage: $storage, laptopSerialNumber: $laptopSerialNumber)';
  }

  @override
  bool operator ==(covariant LaptopModel other) {
    if (identical(this, other)) return true;

    return other.brandName == brandName &&
        other.price == price &&
        other.warrant == warrant &&
        other.ramSize == ramSize &&
        other.storage == storage &&
        other.laptopSerialNumber == laptopSerialNumber;
  }

  @override
  int get hashCode {
    return brandName.hashCode ^
        price.hashCode ^
        warrant.hashCode ^
        ramSize.hashCode ^
        storage.hashCode ^
        laptopSerialNumber.hashCode;
  }
}
