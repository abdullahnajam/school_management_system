import 'package:cloud_firestore/cloud_firestore.dart';

class FeeModel{
  //status = ['paid', 'not paid', 'over due']
  String id,student,studentId,parent,parentId,dueDate,fromDate,discount,discountId,status,feeCategory,feeCategoryId;
  int fees,dueDateInMilli,fromDateInMilli;
  String school,department,academicYear,grade,schoolId,departmentId,gradeId,message,className,classId;
  bool isArchived,isDiscountInPercentage;
  String itemId;
  int amountPaid,amountDue,cashPayment,visaPayment,masterCardPayment;
  int datePosted;



  FeeModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        amountDue = map['amountDue'],
        itemId = map['itemId'],
        message = map['message'],
        className = map['className']??"none",
        classId = map['classId']??"none",
        amountPaid = map['amountPaid'],
        cashPayment = map['cashPayment'],
        visaPayment = map['visaPayment'],
        masterCardPayment = map['masterCardPayment'],
        student = map['student'],
        studentId = map['studentId'],
        parent = map['parent'],
        parentId = map['parentId'],
        dueDate = map['dueDate'],
        fromDate = map['fromDate'],
        fees = map['fees'],
        dueDateInMilli = map['dueDateInMilli'],
        fromDateInMilli = map['fromDateInMilli'],
        isDiscountInPercentage = map['isDiscountInPercentage'],
        discount = map['discount'],
        feeCategory = map['feeCategory'],
        feeCategoryId = map['feeCategoryId'],
        discountId = map['discountId'],
        status = map['status'],
        school = map['school'],
        department = map['department'],
        academicYear = map['academicYear'],
        grade = map['grade'],
        schoolId = map['schoolId'],
        departmentId = map['departmentId'],
        gradeId = map['gradeId'],
        isArchived = map['isArchived'],
        datePosted = map['datePosted'];



  FeeModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}