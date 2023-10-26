import 'dart:convert';

import 'package:wsu_laptops/common/models/student_model.dart';

class ApplicationModel {
  final StudentModel? student;
  final String? studentNumber;
  final String isFunded;
  final String brandName;
  final String? serialNumber;
  final String date;
  final String? status;
  final String? collectionDate;
  ApplicationModel({
    required this.student,
    this.studentNumber,
    required this.isFunded,
    required this.brandName,
    this.serialNumber,
    required this.date,
    this.status,
    this.collectionDate,
  });

  ApplicationModel copyWith({
    StudentModel? student,
    String? studentNumber,
    String? isFunded,
    String? brandName,
    String? serialNumber,
    String? date,
    String? status,
    String? collectionDate,
  }) {
    return ApplicationModel(
      student: student ?? this.student,
      studentNumber: studentNumber ?? this.studentNumber,
      isFunded: isFunded ?? this.isFunded,
      brandName: brandName ?? this.brandName,
      serialNumber: serialNumber ?? this.serialNumber,
      date: date ?? this.date,
      status: status ?? this.status,
      collectionDate: collectionDate ?? this.collectionDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student': student?.toMap(),
      'studentNumber': studentNumber,
      'isFunded': isFunded,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'date': date,
      'status': status,
      'collectionDate': collectionDate,
    };
  }

  Map<String, dynamic> toApp() {
    return <String, dynamic>{
      'studentNumber': student!.studentNumber,
      'isFunded': student!.isFunded,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'status': status,
      'date': date,
      'collectionDate': collectionDate,
    };
  }

  Map<String, dynamic> fromApp() {
    return <String, dynamic>{
      'studentNumber': studentNumber,
      'isFunded': student!.isFunded,
      'brandName': brandName,
      'serialNumber': serialNumber,
      'status': status,
      'date': date,
      'collectionDate': collectionDate,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      student: map['student'] != null
          ? StudentModel.fromMap(map['student'] as Map<String, dynamic>)
          : null,
      studentNumber:
          map['studentNumber'] != null ? map['studentNumber'] as String : null,
      isFunded: map['isFunded'],
      brandName: map['brandName'] as String,
      serialNumber:
          map['serialNumber'] != null ? map['serialNumber'] as String : 'N/A',
      date: map['date'] as String,
      status: map['status'] != null ? map['status'] as String : null,
      collectionDate: map['collectionDate'] != null
          ? map['collectionDate'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationModel.fromJson(String source) =>
      ApplicationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApplicationModel(student: $student, studentNumber $studentNumber, brandName: $brandName, serialNumber: $serialNumber, date: $date, status: $status, collectionDate: $collectionDate, isFunded: $isFunded)';
  }

  @override
  bool operator ==(covariant ApplicationModel other) {
    if (identical(this, other)) return true;

    return other.student == student &&
        other.studentNumber == studentNumber &&
        other.brandName == brandName &&
        other.isFunded == isFunded &&
        other.serialNumber == serialNumber &&
        other.date == date &&
        other.status == status &&
        other.collectionDate == collectionDate;
  }

  @override
  int get hashCode {
    return student.hashCode ^
        studentNumber.hashCode ^
        brandName.hashCode ^
        isFunded.hashCode ^
        serialNumber.hashCode ^
        date.hashCode ^
        status.hashCode ^
        collectionDate.hashCode;
  }
}
