import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolFeeModel{
  /*'fees': feesController.text,
      'school': schoolController.text,
      'department': departmentController.text,
      'grade': _gradeController.text,
      'month': _monthController.text,
      'date': date!.millisecondsSinceEpoch,
      'isArchived': false,
      'status':"Active",
      'datePosted': DateTime.now().millisecondsSinceEpoch,*/
  String id,fees,school,schoolId,department,departmentId,grade,gradeId,month,status;
  int date;
  bool isArchived;
  int datePosted;



  SchoolFeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        month = map['month'],
        status = map['status'],
        school = map['school'],
        schoolId = map['schoolId'],
        department = map['department'],
        departmentId = map['departmentId'],
        grade = map['grade'],
        gradeId = map['gradeId'],
        date = map['date'],
        fees = map['fees'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  SchoolFeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}