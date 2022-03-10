import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel{
  String id,firstName,lastName,job,address,photo,phone,email,status;
  bool isArchived;
  int datePosted;



  ParentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        status = map['status'],
        lastName = map['lastName'],
        job = map['job'],
        address = map['address'],
        photo = map['photo'],
        phone = map['phone'],
        email = map['email'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  ParentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}