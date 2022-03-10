import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel{
  String id,name,code,subject,subjectID,rentOrOwn,edition,supplier,supplierId;
  int stock,cost;
  bool isArchived;
  int datePosted;



  BookModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        subject = map['subject'],
        subjectID = map['subjectID'],
        rentOrOwn = map['rentOrOwn'],
        stock = map['stock'],
        cost = map['cost'],
        supplier = map['supplier'],
        supplierId = map['supplierId'],
        edition = map['edition'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BookModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}