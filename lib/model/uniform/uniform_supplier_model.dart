import 'package:cloud_firestore/cloud_firestore.dart';

class UniformSupplierModel{
  String id,name,phone,email;
  bool isArchived;
  int datePosted;



  UniformSupplierModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        phone = map['phone'],
        isArchived = map['isArchived'],
        email = map['email'],
        datePosted = map['datePosted'];



  UniformSupplierModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}