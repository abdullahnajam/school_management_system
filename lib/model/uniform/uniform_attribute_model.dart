import 'package:cloud_firestore/cloud_firestore.dart';

class UniformAttributeModel{
  String id,name;
  bool isArchived;
  int datePosted;


  UniformAttributeModel(this.id, this.name, this.isArchived, this.datePosted);

  UniformAttributeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  UniformAttributeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}

class SelectedUniformItemAttributeModel{
  String id,name,attributeId;
  List valueIds;


  SelectedUniformItemAttributeModel(
      this.id, this.name, this.attributeId, this.valueIds);

  SelectedUniformItemAttributeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        attributeId = map['attributeId'],
        valueIds = map['valueIds'];



  SelectedUniformItemAttributeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}