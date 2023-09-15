// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wsu_laptops/common/models/laptop_model.dart';

class StudentModel {
  String studentNumber;
  String name;
  String surname;
  String department;
  String course;
  String status;
  String isFunded;
  LaptopModel? laptopModel;
  StudentModel({
    required this.studentNumber,
    required this.name,
    required this.surname,
    required this.department,
    required this.course,
    required this.status,
    required this.isFunded,
    this.laptopModel,
  });

  StudentModel copyWith({
    String? studentNumber,
    String? name,
    String? surname,
    String? department,
    String? course,
    String? status,
    String? isFunded,
    LaptopModel? laptopModel,
  }) {
    return StudentModel(
      studentNumber: studentNumber ?? this.studentNumber,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      department: department ?? this.department,
      course: course ?? this.course,
      status: status ?? this.status,
      isFunded: isFunded ?? this.isFunded,
      laptopModel: laptopModel ?? this.laptopModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentNumber': studentNumber,
      'name': name,
      'surname': surname,
      'department': department,
      'course': course,
      'status': status,
      'isFunded': isFunded,
      'laptopModel': laptopModel?.toMap(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentNumber: map['studentNumber'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      department: map['department'] as String,
      course: map['course'] as String,
      status: map['status'] as String,
      isFunded: map['isFunded'] as String,
      laptopModel: map['laptopModel'] != null
          ? LaptopModel.fromMap(map['laptopModel'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentModel(studentNumber: $studentNumber, name: $name, surname: $surname, department: $department, course: $course, status: $status, isFunded: $isFunded, laptopModel: $laptopModel)';
  }

  @override
  bool operator ==(covariant StudentModel other) {
    if (identical(this, other)) return true;

    return other.studentNumber == studentNumber &&
        other.name == name &&
        other.surname == surname &&
        other.department == department &&
        other.course == course &&
        other.status == status &&
        other.isFunded == isFunded &&
        other.laptopModel == laptopModel;
  }

  @override
  int get hashCode {
    return studentNumber.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        department.hashCode ^
        course.hashCode ^
        status.hashCode ^
        isFunded.hashCode ^
        laptopModel.hashCode;
  }
}
