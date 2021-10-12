import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel{
  String id,name,school,department,schoolId,departmentId,category,categoryId,status,photo,nationalId,uniqueId;
  bool isArchived;
  int datePosted;



  EmployeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        school = map['school'],
        uniqueId = map['uniqueId'],
        department = map['department'],
        schoolId = map['schoolId'],
        departmentId = map['departmentId'],
        category = map['category'],
        categoryId = map['categoryId'],
        status = map['status'],
        photo = map['photo'],
        nationalId = map['nationalId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  EmployeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}