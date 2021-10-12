import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel{
  String id,firstName,lastName,email,password,phone,address,photo;
  String school,schoolId,departmentId,department,grade,gradeId,className,classId;
  String parent,parentId,relation,uniqueId;
  bool isArchived;
  int datePosted;
  int siblings;
  List siblingsIds;
  String token,status,topic;




  StudentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        uniqueId = map['uniqueId'],
        relation = map['relation'],
        password = map['password'],
        phone = map['phone'],
        address = map['address'],
        photo = map['photo'],
        token = map['token'],
        status = map['status'],
        topic = map['topic'],
        school = map['school'],
        schoolId = map['schoolId'],
        departmentId = map['departmentId'],
        department = map['department'],
        grade = map['grade'],
        gradeId = map['gradeId'],
        className = map['className'],
        siblings = map['siblings'],
        siblingsIds = map['siblingsIds'],
        classId = map['classId'],
        parent = map['parent'],
        parentId = map['parentId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  StudentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}