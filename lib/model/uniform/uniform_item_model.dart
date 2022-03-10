import 'package:cloud_firestore/cloud_firestore.dart';

class UniformItemModel{
  String id,name,code,categoryId,category,description,quantity,image,lowStockQuantity;
  List gallery;
  int price,stock,sku;
  bool isArchived;
  int datePosted;



  UniformItemModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        gallery = map['gallery']??[],
        lowStockQuantity = map['lowStockQuantity']??"0",
        categoryId = map['categoryId'],
        category = map['category'],
        description = map['description'],
        quantity = map['quantity'],
        image = map['image'],
        stock = map['stock'],
        sku = map['sku'],
        isArchived = map['isArchived'],
        price = map['price'],
        datePosted = map['datePosted'];


  UniformItemModel(
      this.id,
      this.name,
      this.code,
      this.lowStockQuantity,
      this.gallery,
      this.categoryId,
      this.category,
      this.description,
      this.quantity,
      this.image,
      this.price,
      this.stock,
      this.sku,
      this.isArchived,
      this.datePosted);

  UniformItemModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}