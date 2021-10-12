import 'package:cloud_firestore/cloud_firestore.dart';

class BookDeliveryModel{
  String id,student,studentId;
  List bookIds;
  bool isArchived;
  int datePosted;



  BookDeliveryModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        bookIds = map['bookIds'],
        student = map['student'],
        studentId = map['studentId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BookDeliveryModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}