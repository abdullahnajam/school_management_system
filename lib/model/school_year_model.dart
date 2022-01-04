import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolYearModel{
  String id,year,startDate;
  int dateInMilliSeconds;
  bool isArchived;
  int datePosted;



  SchoolYearModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        year = map['year'],
        startDate = map['startDate'],
        dateInMilliSeconds = map['dateInMilliSeconds'],

        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  SchoolYearModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}