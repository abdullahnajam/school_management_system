import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityFeeModel{
  /*'fees': feesController.text,
      'school': schoolController.text,
      'department': departmentController.text,
      'grade': _gradeController.text,
      'month': _monthController.text,
      'date': date!.millisecondsSinceEpoch,
      'isArchived': false,
      'status':"Active",
      'datePosted': DateTime.now().millisecondsSinceEpoch,*/
  String id,fees,school,schoolId,department,departmentId,activity,activityId,status;
  bool isArchived;
  int datePosted;



  ActivityFeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        activity = map['activity'],
        status = map['status'],
        school = map['school'],
        schoolId = map['schoolId'],
        department = map['department'],
        departmentId = map['departmentId'],
        activityId = map['activityId'],
        fees = map['fees'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  ActivityFeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}