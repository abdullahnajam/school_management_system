import 'package:cloud_firestore/cloud_firestore.dart';

class BusFeeModel{
  /*'fees': feesController.text,
      'school': schoolController.text,
      'department': departmentController.text,
      'grade': _gradeController.text,
      'month': _monthController.text,
      'date': date!.millisecondsSinceEpoch,
      'isArchived': false,
      'status':"Active",
      'datePosted': DateTime.now().millisecondsSinceEpoch,*/
  String id,fees,busLine,busLineId,status;
  bool isArchived;
  int datePosted;



  BusFeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        busLine = map['busLine'],
        status = map['status'],
        busLineId = map['busLineId'],

        fees = map['fees'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusFeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}