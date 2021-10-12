import 'package:cloud_firestore/cloud_firestore.dart';

class UniformDeliveryModel{
  String id,student,studentId,payment,status;
  bool isArchived;
  List item;
  int datePosted;



  UniformDeliveryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        student = map['student'],
        studentId = map['studentId'],
        item = map['item'],
        payment = map['payment'],
        status = map['status'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  UniformDeliveryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}