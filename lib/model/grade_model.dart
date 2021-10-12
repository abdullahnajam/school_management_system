import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel{
  String id,name,school,department,schoolId,departmentId,totalTerms,currentTerm;
  bool isArchived;
  int datePosted;



  GradeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        school = map['school'],
        department = map['department'],
        schoolId = map['schoolId'],
        departmentId = map['departmentId'],
        totalTerms = map['totalTerms'],
        currentTerm = map['currentTerm'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  GradeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}