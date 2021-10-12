import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id,name,mainCategoryName,mainCategoryId;
  bool isSubCategory,isArchived;
  int datePosted;



  CategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        mainCategoryName = map['mainCategoryName'],
        mainCategoryId = map['mainCategoryId'],
        isSubCategory = map['isSubCategory'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  CategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}