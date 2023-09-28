// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wsu_laptops/common/models/student_model.dart';

class ApplicationModel {
  final StudentModel student;
  final String brandName;
  final String? serialNumber;
  final String date;
  final String? status;
  ApplicationModel({
    required this.student,
    required this.brandName,
    this.serialNumber,
    required this.date,
    this.status,
  });

  ApplicationModel copyWith({
    StudentModel? student,
    String? brandName,
    String? serialNumber,
    String? date,
    String? status,
  }) {
    return ApplicationModel(
      student: student ?? this.student,
      brandName: brandName ?? this.brandName,
      serialNumber: serialNumber ?? this.serialNumber,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student': student.toMap(),
      'brandName': brandName,
      'serialNumber': serialNumber,
      'date': date,
      'status': status,
    };
  }

  Map<String, dynamic> toApp() {
    return <String, dynamic>{
      'studentNumber': student.studentNumber,
      'isFunded': student.isFunded,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'status': status,
      'date': date,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      student: StudentModel.fromMap(map['student'] as Map<String, dynamic>),
      brandName: map['brandName'] as String,
      serialNumber:
          map['serialNumber'] != null ? map['serialNumber'] as String : 'N/A',
      date: map['date'] as String,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationModel.fromJson(String source) =>
      ApplicationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApplicationModel(student: $student, brandName: $brandName, serialNumber: $serialNumber, date: $date, status: $status)';
  }

  @override
  bool operator ==(covariant ApplicationModel other) {
    if (identical(this, other)) return true;

    return other.student == student &&
        other.brandName == brandName &&
        other.serialNumber == serialNumber &&
        other.date == date &&
        other.status == status;
  }

  @override
  int get hashCode {
    return student.hashCode ^
        brandName.hashCode ^
        serialNumber.hashCode ^
        date.hashCode ^
        status.hashCode;
  }
}
