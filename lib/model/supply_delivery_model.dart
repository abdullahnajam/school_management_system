import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyDeliveryModel{
  String id,type,customerName,customerId,payment,status;
  bool isArchived;
  List item;
  int datePosted;



  SupplyDeliveryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        customerName = map['customerName'],
        customerId = map['customerId'],
        type = map['type'],
        item = map['item'],
        payment = map['payment'],
        status = map['status'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  SupplyDeliveryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}