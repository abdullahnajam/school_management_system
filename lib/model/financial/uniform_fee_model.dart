import 'package:cloud_firestore/cloud_firestore.dart';

class UniformFeeModel{
  
  String id,fees,uniformItem,uniformItemId,status;
  bool isArchived;
  int datePosted;



  UniformFeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        uniformItem = map['uniformItem'],
        status = map['status'],
        uniformItemId = map['uniformItemId'],

        fees = map['fees'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  UniformFeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}