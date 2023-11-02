// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentModel {
  String studentNumber;
  String? pin;
  String name;
  String surname;
  String gender;
  String faculty;
  String qualification;
  String level;
  String campus;
  String number;
  String isFunded;
  StudentModel({
    required this.studentNumber,
    this.pin,
    required this.name,
    required this.surname,
    required this.gender,
    required this.faculty,
    required this.qualification,
    required this.level,
    required this.campus,
    required this.number,
    required this.isFunded,
  });

  StudentModel copyWith({
    String? studentNumber,
    String? pin,
    String? name,
    String? surname,
    String? gender,
    String? faculty,
    String? qualification,
    String? level,
    String? campus,
    String? number,
    String? isFunded,
  }) {
    return StudentModel(
      studentNumber: studentNumber ?? this.studentNumber,
      pin: pin ?? this.pin,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      faculty: faculty ?? this.faculty,
      qualification: qualification ?? this.qualification,
      level: level ?? this.level,
      campus: campus ?? this.campus,
      number: number ?? this.number,
      isFunded: isFunded ?? this.isFunded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentNumber': studentNumber,
      'pin': pin,
      'name': name,
      'surname': surname,
      'gender': gender,
      'faculty': faculty,
      'qualification': qualification,
      'level': level,
      'campus': campus,
      'number': number,
      'isFunded': isFunded,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentNumber: map['studentNumber'] as String,
      pin: map['pin'] != null ? map['pin'] as String : null,
      name: map['name'] as String,
      surname: map['surname'] as String,
      gender: map['gender'] as String,
      faculty: map['faculty'] as String,
      qualification: map['qualification'] as String,
      level: map['level'] as String,
      campus: map['campus'] as String,
      number: map['number'] as String,
      isFunded: map['isFunded'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentModel(studentNumber: $studentNumber, pin: $pin, name: $name, surname: $surname, gender: $gender, faculty: $faculty, qualification: $qualification, level: $level, campus: $campus, number: $number, isFunded: $isFunded)';
  }

  @override
  bool operator ==(covariant StudentModel other) {
    if (identical(this, other)) return true;

    return other.studentNumber == studentNumber &&
        other.pin == pin &&
        other.name == name &&
        other.surname == surname &&
        other.gender == gender &&
        other.faculty == faculty &&
        other.qualification == qualification &&
        other.level == level &&
        other.campus == campus &&
        other.number == number &&
        other.isFunded == isFunded;
  }

  @override
  int get hashCode {
    return studentNumber.hashCode ^
        pin.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        gender.hashCode ^
        faculty.hashCode ^
        qualification.hashCode ^
        level.hashCode ^
        campus.hashCode ^
        number.hashCode ^
        isFunded.hashCode;
  }
}
