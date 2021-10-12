import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountModel{
  String id,name,type,category,categoryId;
  int value;
  bool isArchived;
  int datePosted;



  DiscountModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        type = map['type'],
        category = map['category'],
        categoryId = map['categoryId'],
        value = map['value'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  DiscountModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}