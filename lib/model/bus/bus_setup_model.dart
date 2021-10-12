import 'package:cloud_firestore/cloud_firestore.dart';

class BusSetUpModel{
  String id,busId,busNumber,driver,driverId,coordinator,coordinatorId,line,lineId;
  int order;
  List students;
  bool isArchived;
  int datePosted;



  BusSetUpModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        busId = map['busId'],
        busNumber = map['busNumber'],
        students = map['students'],
        order = map['order'],
        driver = map['driver'],
        driverId = map['driverId'],
        coordinator = map['coordinator'],
        coordinatorId = map['coordinatorId'],
        line = map['line'],
        lineId = map['lineId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  BusSetUpModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}