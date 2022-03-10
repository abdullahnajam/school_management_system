import 'package:cloud_firestore/cloud_firestore.dart';

class VariantModel{
  String id,name,price,sku,quantity,image,itemId,item;
  bool isArchived;
  int datePosted;


  VariantModel(this.id, this.name, this.price, this.sku, this.quantity,
      this.image, this.itemId, this.item, this.isArchived, this.datePosted);

  VariantModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        itemId = map['itemId'],
        item = map['item'],
        price = map['price'],
        quantity = map['quantity'],
        image = map['image'],
        isArchived = map['isArchived'],
        sku = map['sku'],
        datePosted = map['datePosted'];



  VariantModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
