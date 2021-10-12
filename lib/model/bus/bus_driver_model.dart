import 'package:cloud_firestore/cloud_firestore.dart';

class BusDriverModel{
  String id,name,nationalId,phone,address,licenseNumber,uniqueId;
  bool isArchived;
  int datePosted;



  BusDriverModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        nationalId = map['nationalId'],
        phone = map['phone'],
        uniqueId = map['uniqueId'],
        address = map['address'],
        licenseNumber = map['licenseNumber'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusDriverModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}