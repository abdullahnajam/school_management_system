import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel{
  String id,email,name,photo,phone,address,nationalId,bloodType,status,uniqueId;
  List schools,departments,subjects;
  String duty;

  bool isArchived;
  int datePosted;



  TeacherModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        email = map['email'],
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
        duty = map['duty'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  TeacherModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}