import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInfoModel{
  String id,itemId,depositorName,message,visaPaymentDate,bankPaymentDate,receiptNumber,bankReceiptNumber
  ,image,discountCategory,discountName,finalAmount;
  int amountPaid,amountDue,cashPayment,visaPayment,masterCardPayment;
  bool isArchived;
  int datePosted;




  PaymentInfoModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        itemId = map['itemId']??"",
        depositorName = map['depositorName']??"",
        message = map['message']??"",
        visaPaymentDate = map['visaPaymentDate']??"",
        bankPaymentDate = map['bankPaymentDate']??"",
        receiptNumber = map['receiptNumber']??"",
        bankReceiptNumber = map['bankReceiptNumber']??"",
        image = map['image']??"",
        discountCategory = map['discountCategory'],
        discountName = map['discountName'],
        finalAmount = map['finalAmount'],
        amountPaid = map['amountPaid'],
        amountDue = map['amountDue'],
        cashPayment = map['cashPayment'],
        visaPayment = map['visaPayment'],
        masterCardPayment = map['masterCardPayment'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  PaymentInfoModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}