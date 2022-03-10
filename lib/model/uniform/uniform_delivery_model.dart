import 'package:cloud_firestore/cloud_firestore.dart';

class UniformDeliveryModel{
  String id,student,studentId,payment,status;
  bool isArchived;
  List item,quantities,variants;
  int datePosted,amount;




  UniformDeliveryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        student = map['student'],
        studentId = map['studentId'],
        amount = map['amount']??0,
        variants = map['variants']??[],
        quantities = map['quantities']??[],
        item = map['item'],
        payment = map['payment'],
        status = map['status'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  UniformDeliveryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
