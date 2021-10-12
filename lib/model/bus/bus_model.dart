import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel{
  String id,brand,code,license,busNumber;
  int capacity;
  bool isArchived;
  int datePosted;



  BusModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        brand = map['brand'],
        code = map['code'],
        license = map['license'],
        busNumber = map['busNumber'],
        capacity = map['capacity'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}