import 'package:cloud_firestore/cloud_firestore.dart';

class UniformItemModel{
  String id,name,code,categoryId,category,variation,variationId;
  int price,stock,sku;
  bool isArchived;
  int datePosted;



  UniformItemModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        categoryId = map['categoryId'],
        category = map['category'],
        variation = map['variation'],
        variationId = map['variationId'],
        stock = map['stock'],
        sku = map['sku'],
        isArchived = map['isArchived'],
        price = map['price'],
        datePosted = map['datePosted'];



  UniformItemModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}