import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolModel{
  String id,name,abbreviation,year,logo;
  bool isArchived;
  int datePosted;



  SchoolModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        abbreviation = map['abbreviation'],
        logo = map['logo'],

        year = map['year'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  SchoolModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}