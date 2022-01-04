import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel{
  String id,name,school,schoolId,department,departmentId,category,categoryId;
  bool isArchived;
  int datePosted;


  PlaceModel(
      this.id,
      this.name,
      this.school,
      this.schoolId,
      this.department,
      this.departmentId,
      this.category,
      this.categoryId,
      this.isArchived,
      this.datePosted);

  PlaceModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'],
        school = map['school'],
        schoolId = map['schoolId'],
        department = map['department'],
        departmentId = map['departmentId'],
        category = map['category'],

        categoryId = map['categoryId'];



  PlaceModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}