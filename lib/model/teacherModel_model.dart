import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel{
  String id,email,name,photo,phone,address,nationalId,bloodType,status,uniqueId,staff,staffId;
  List schools,departments,subjects;
  bool assignDuty;
  int lessonCapacity;

  bool isArchived;
  int datePosted;



  TeacherModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        lessonCapacity = map['lessonCapacity']??0,
        email = map['email'],
        staff = map['staff']??"",
        staffId = map['staffId']??"",
        assignDuty = map['assignDuty']??false,
        photo = map['photo'],
        phone = map['phone'],
        uniqueId = map['uniqueId'],
        status = map['status'],
        address = map['address'],
        nationalId = map['nationalId'],
        bloodType = map['bloodType'],
        schools = map['schools'],
        departments = map['departments'],
        subjects = map['subjects'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  TeacherModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}