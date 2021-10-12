import 'package:cloud_firestore/cloud_firestore.dart';

class BusCoordinatorModel{
  String id,name,nationalId,phone,address,uniqueId;
  bool isArchived;
  int datePosted;



  BusCoordinatorModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        uniqueId = map['uniqueId'],
        nationalId = map['nationalId'],
        phone = map['phone'],
        address = map['address'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusCoordinatorModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}