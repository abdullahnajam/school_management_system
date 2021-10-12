import 'package:cloud_firestore/cloud_firestore.dart';

class CodeModel{
  int student,teacher,coordinator,driver,employee;



  CodeModel.fromMap(Map<String,dynamic> map)
      :
        student = map['student'],
        teacher = map['teacher'],
        coordinator = map['coordinator'],
        driver = map['driver'],
        employee = map['employee'];



  CodeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}