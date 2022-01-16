import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel{
  String id,name,school,department,schoolId,departmentId,subject,subjectId,place,placeId;
  bool isArchived;
  int datePosted;



  StaffModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        school = map['school'],
        department = map['department'],
        schoolId = map['schoolId'],
        subject = map['subject'],
        subjectId = map['subjectId'],
        departmentId = map['departmentId'],
        place = map['place'],
        placeId = map['placeId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  StaffModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}