import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel{
  String id,role;
 // List access;




  RoleModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        role = map['role'];
        //access = map['access'];



  RoleModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}