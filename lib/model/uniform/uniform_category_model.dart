import 'package:cloud_firestore/cloud_firestore.dart';

class UniformCategoryModel{
  String id,name,code,mainCategoryId,mainCategoryName,departmentId,department;
  bool isArchived,isSub;
  int datePosted;



  UniformCategoryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        mainCategoryId = map['mainCategoryId'],
        mainCategoryName = map['mainCategoryName'],
        departmentId = map['departmentId'],
        department = map['department'],
        isArchived = map['isArchived'],
        isSub = map['isSub'],
        datePosted = map['datePosted'];



  UniformCategoryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}