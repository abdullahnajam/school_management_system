import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel{
  String id,name,code,school,schoolId,department,departmentId,coordinator,coordinatorId,coordinatorType,date,supplies,status;
  int fees,numberOfDays,capacity,dateInMilli;
  String student,studentId;
  List classes;
  bool isArchived;
  int datePosted;



  ActivityModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        student = map['student'],
        studentId = map['studentId'],
        status = map['status'],
        code = map['code'],
        school = map['school'],
        schoolId = map['schoolId'],
        department = map['department'],
        departmentId = map['departmentId'],
        coordinator = map['coordinator'],
        coordinatorId = map['coordinatorId'],
        coordinatorType = map['coordinatorType'],
        date = map['date'],
        dateInMilli = map['dateInMilli'],
        supplies = map['supplies'],
        fees = map['fees'],
        numberOfDays = map['numberOfDays'],
        capacity = map['capacity'],
        classes = map['classes'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  ActivityModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}