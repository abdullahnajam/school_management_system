import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel{
  String id,name,school,department,schoolId,departmentId,grade,gradeId;
  int maxCapacity,minCapacity;
  bool isArchived;
  int datePosted;



  ClassModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        school = map['school'],
        department = map['department'],
        schoolId = map['schoolId'],
        grade = map['grade'],
        gradeId = map['gradeId'],
        departmentId = map['departmentId'],
        maxCapacity = map['maxCapacity'],
        minCapacity = map['minCapacity'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  ClassModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}