import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel{
  String id,name,school,department,schoolId,departmentId,grade,gradeId,classes,classId;

  bool isArchived;
  int datePosted;



  SubjectModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        school = map['school'],
        classes = map['classes'],
        classId = map['classId'],
        department = map['department'],
        schoolId = map['schoolId'],
        grade = map['grade'],
        gradeId = map['gradeId'],
        departmentId = map['departmentId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  SubjectModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}