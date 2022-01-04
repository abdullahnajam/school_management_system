import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:school_management_system/components/academic/classes/class_list.dart';
import 'package:school_management_system/components/financial/school_fees/school_fee_list.dart';
import 'package:school_management_system/model/codeModel.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'activity_fee_list.dart';

class ActivityFees extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  ActivityFees(this._scaffoldKey);

  @override
  _ActivityFeesState createState() => _ActivityFeesState();
}

class _ActivityFeesState extends State<ActivityFees> {

  var feesController=TextEditingController();
  var schoolController=TextEditingController();
  var departmentController=TextEditingController();
  var activityController=TextEditingController();
  add(String schoolId,departmentId,activityId) async{
    print("rr");
    final f = new DateFormat('MM-yyyy');
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('activity_fees').add({
      'fees': feesController.text,
      'school': schoolController.text,
      'department': departmentController.text,
      'activity': activityController.text,
      'isArchived': false,
      'schoolId': schoolId,
      'departmentId': departmentId,
      'activityId': activityId,
      'status':"Active",
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) async{
      await FirebaseFirestore.instance.collection('students').where("departmentId",isEqualTo:departmentId).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          StudentModel stdModel=StudentModel.fromMap(data, doc.reference.id);

          FirebaseFirestore.instance.collection('fees').add({
            'student': "${stdModel.firstName} ${stdModel.lastName}",
            'school': schoolController.text,
            'department': departmentController.text,
            'studentId': stdModel.id,
            'parentId':stdModel.parentId,
            'parent': stdModel.parent,
            'schoolId': schoolId,
            'dueDate': f.format(DateTime.now()),
            'fromDate': f.format(DateTime.now()),
            'discount': "",
            'discountId': "",
            'feeCategoryId': "",
            'feeCategory': "Activity Fee",
            'fees': int.parse(feesController.text),
            'academicYear': "2022",
            'dueDateInMilli': 0,
            'fromDateInMilli': 0,
            'grade':stdModel.grade,
            'message':"none",
            'gradeId': stdModel.gradeId,
            'departmentId': departmentId,
            'isArchived': false,
            'isDiscountInPercentage': false,
            'status':"Not Paid",
            //amountPaid,amountDue,cashPayment,visaPayment,masterCardPayment
            'amountPaid': 0,
            'amountDue': int.parse(feesController.text),
            'cashPayment': 0,
            'visaPayment': 0,
            'masterCardPayment': 0,
            'datePosted': DateTime.now().millisecondsSinceEpoch,
          });
        });
      });
      pr.close();
      print("added");
      Navigator.pop(context);
    }).onError((error, stackTrace){
      pr.close();
      print("school fee error ${error.toString()}");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddDialog() async {
    String schoolId="",departmentId="",_activityId="";
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Add Activity Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.close,color: Colors.grey,),
                                onPressed: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "School",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return StatefulBuilder(
                                      builder: (context,setState){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          insetAnimationDuration: const Duration(seconds: 1),
                                          insetAnimationCurve: Curves.fastOutSlowIn,
                                          elevation: 2,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('schools').snapshots(),
                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                        Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );
                                                }

                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.data!.size==0){
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                        Text("No Activitys Added",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );

                                                }

                                                return new ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                    return new Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: ListTile(
                                                        onTap: (){
                                                          setState(() {
                                                            schoolController.text="${data['name']}";
                                                            schoolId=document.reference.id;
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage: NetworkImage(data['logo']),
                                                          backgroundColor: Colors.indigoAccent,
                                                          foregroundColor: Colors.white,
                                                        ),
                                                        title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            controller: schoolController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Department",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return StatefulBuilder(
                                      builder: (context,setState){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          insetAnimationDuration: const Duration(seconds: 1),
                                          insetAnimationCurve: Curves.fastOutSlowIn,
                                          elevation: 2,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('departments')
                                                  .where("schoolName",isEqualTo: schoolController.text).snapshots(),
                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                        Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );
                                                }

                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.data!.size==0){
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                        Text("No Departments Added",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );

                                                }

                                                return new ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                    return new Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: ListTile(
                                                        onTap: (){
                                                          setState(() {
                                                            departmentController.text="${data['name']}";
                                                            departmentId=document.reference.id;
                                                          });
                                                          Navigator.pop(context);
                                                        },

                                                        title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            controller: departmentController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Activity",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return StatefulBuilder(
                                      builder: (context,setState){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          insetAnimationDuration: const Duration(seconds: 1),
                                          insetAnimationCurve: Curves.fastOutSlowIn,
                                          elevation: 2,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*0.3,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('activities')
                                                  .where('departmentId',isEqualTo:departmentId).snapshots(),
                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                        Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );
                                                }

                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                if (snapshot.data!.size==0){
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                        Text("No Activity Added",style: TextStyle(color: Colors.black))

                                                      ],
                                                    ),
                                                  );

                                                }

                                                return new ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                    return new Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: ListTile(
                                                        onTap: (){
                                                          setState(() {
                                                            activityController.text="${data['name']}";
                                                            _activityId=document.reference.id;
                                                          });
                                                          Navigator.pop(context);
                                                        },

                                                        title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                            controller: activityController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fees",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            controller: feesController,
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          print("tap");
                          if (_formKey.currentState!.validate()) {
                            add(schoolId,departmentId,_activityId);
                          }

                        },
                        child: Container(
                          height: 50,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Add Fees",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Activity Fees",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical:
                                defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {
                              _showAddDialog();
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Fee"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      ActivityFeeList(),

                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),



              ],
            )
          ],
        ),
      ),
    );
  }
}
