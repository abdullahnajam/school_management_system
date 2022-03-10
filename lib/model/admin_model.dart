import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel{
  String id,username,email,role,roleId;
  bool addAdmin;

  AdminModel(this.id, this.username, this.email,this.role, this.roleId,this.addAdmin);

  AdminModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        username = map['username'],
        email = map['email'],

        role = map['role'],
        addAdmin = map['addAdmin'],


        roleId = map['roleId'];



  AdminModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}