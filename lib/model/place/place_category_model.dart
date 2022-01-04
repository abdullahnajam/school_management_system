import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceCategoryModel{
  String id,name,school,schoolId,mainCategoryName,mainCategoryId;
  bool isArchived,isSubCategory;
  int datePosted;


  PlaceCategoryModel(
      this.id,
      this.name,
      this.school,
      this.isSubCategory,
      this.schoolId,
      this.mainCategoryName,
      this.mainCategoryId,
      this.isArchived,
      this.datePosted);

  PlaceCategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'],
        school = map['school'],
        isSubCategory = map['isSubCategory'],
        schoolId = map['schoolId'],
        mainCategoryName = map['mainCategoryName'],
        mainCategoryId = map['mainCategoryId'];



  PlaceCategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}