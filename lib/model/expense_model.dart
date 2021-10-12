import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel{
  String id,type,typeId,amount,date,note,paymentMethod,status,dueDate;
  bool isArchived;
  int datePosted;
  int dateInMilli,dueDateInMilli;
  ExpenseModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        type = map['type'],
        typeId = map['typeId'],
        date = map['date'],
        note = map['note'],
        datePosted = map['datePosted'],
        dateInMilli = map['dateInMilli'],
        dueDateInMilli = map['dueDateInMilli'],
        paymentMethod = map['paymentMethod'],
        status = map['status'],
        isArchived = map['isArchived'],
        dueDate = map['dueDate'],
        amount = map['amount'];



  ExpenseModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}