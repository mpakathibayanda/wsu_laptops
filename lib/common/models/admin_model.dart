// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdminModel {
  final String staffNumber;
  final String pin;
  final String name;
  final String surname;
  final String gender;
  final String role;
  final String site;
  AdminModel({
    required this.staffNumber,
    required this.pin,
    required this.name,
    required this.surname,
    required this.gender,
    required this.role,
    required this.site,
  });

  AdminModel copyWith({
    String? staffNumber,
    String? pin,
    String? name,
    String? surname,
    String? gender,
    String? role,
    String? site,
  }) {
    return AdminModel(
      staffNumber: staffNumber ?? this.staffNumber,
      pin: pin ?? this.pin,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      site: site ?? this.site,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staffNumber': staffNumber,
      'pin': pin,
      'name': name,
      'surname': surname,
      'gender': gender,
      'role': role,
      'site': site,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      staffNumber: map['staffNumber'] as String,
      pin: map['pin'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      gender: map['gender'] as String,
      role: map['role'] as String,
      site: map['site'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminModel(staffNumber: $staffNumber, pin: $pin, name: $name, surname: $surname, gender: $gender, role: $role, site: $site)';
  }

  @override
  bool operator ==(covariant AdminModel other) {
    if (identical(this, other)) return true;

    return other.staffNumber == staffNumber &&
        other.pin == pin &&
        other.name == name &&
        other.surname == surname &&
        other.gender == gender &&
        other.role == role &&
        other.site == site;
  }

  @override
  int get hashCode {
    return staffNumber.hashCode ^
        pin.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        gender.hashCode ^
        role.hashCode ^
        site.hashCode;
  }
}
