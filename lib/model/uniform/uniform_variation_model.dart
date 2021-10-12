import 'package:cloud_firestore/cloud_firestore.dart';

class UniformVariationModel{
  String id,name,code,value;
  bool isArchived;
  int datePosted;



  UniformVariationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        code = map['code'],
        isArchived = map['isArchived'],
        value = map['value'],
        datePosted = map['datePosted'];



  UniformVariationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}