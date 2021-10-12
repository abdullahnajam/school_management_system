import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel{
  String id,name,schoolName,schoolId,mainDepartmentName,mainDepartmentId;
  bool isSubDepartment,isArchived;
  int datePosted;



  DepartmentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        schoolName = map['schoolName'],
        schoolId = map['schoolId'],
        mainDepartmentName = map['mainDepartmentName'],
        mainDepartmentId = map['mainDepartmentId'],
        isSubDepartment = map['isSubDepartment'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  DepartmentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}