import 'package:cloud_firestore/cloud_firestore.dart';

class UniformStockModel{
  String id,supplier,supplierId,itemId,item;
  int price,amount;
  bool isArchived;
  int datePosted;



  UniformStockModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        supplier = map['supplier'],
        supplierId = map['supplierId'],
        itemId = map['itemId'],
        item = map['item'],
        amount = map['amount'],
        price = map['price'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  UniformStockModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}