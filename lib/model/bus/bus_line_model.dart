import 'package:cloud_firestore/cloud_firestore.dart';

class BusLineModel{
  String id,code,name,dropType;
  int fees;
  bool isArchived;
  int datePosted;



  BusLineModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        dropType = map['dropType'],
        fees = map['fees'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusLineModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}