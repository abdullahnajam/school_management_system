import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/components/school_supplies/supply_delivery/supply_delivery_list.dart';
import 'package:school_management_system/model/checklist_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;



class SupplyDelivery extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  SupplyDelivery(this._scaffoldKey);

  @override
  _SupplyDeliveryState createState() => _SupplyDeliveryState();
}

class _SupplyDeliveryState extends State<SupplyDelivery> {

  var _studentController=TextEditingController();
  var _schoolController=TextEditingController();
  var _departmentController=TextEditingController();
  var _parentController=TextEditingController();
  var _academicYearController=TextEditingController();
  var _gradeController=TextEditingController();
  var _dueDateController=TextEditingController();
  var _fromDateController=TextEditingController();

  String _schoolId="",_departmentId="";
  String _parentId="";
  String _gradeId="";
  String type='Student';

  DateTime? dueDate,fromDate;
  int dueDateInMilli=DateTime.now().millisecondsSinceEpoch;
  int fromDateInMilli=DateTime.now().millisecondsSinceEpoch;


  add(String _studentId,List _itemId,int fees) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    String payment="Not Paid";
    if(type!='Student')
      payment="Free";
    FirebaseFirestore.instance.collection('supply_deliveries').add({
      'customerName': _studentController.text,
      'item': _itemId,
      'customerId': _studentId,
      'status': "Pending",
      'payment': payment,
      'isArchived': false,
      'type': type,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      if(type=='Student')
        FirebaseFirestore.instance.collection('fees').add({
        'student': _studentController.text,
        'school': _schoolController.text,
          'itemId': value.id,
        'department': _departmentController.text,
        'studentId': _studentId,
        'parentId': _parentId,
        'parent': _parentController.text,
        'schoolId': _schoolId,
        'dueDate': _dueDateController.text,
        'fromDate': _fromDateController.text,
        'discount': "none",
        'discountId': "none",
        'feeCategoryId': "none",
        'feeCategory': "Supply Fees",
        'fees': fees,
        'academicYear': _academicYearController.text,
        'dueDateInMilli': dueDateInMilli,
        'fromDateInMilli': fromDateInMilli,
        'grade': _gradeController.text,
        'message':"none",
        'gradeId': _gradeId,
        'departmentId': _departmentId,
        'isArchived': false,
        'isDiscountInPercentage': false,
        'status':"Not Paid",
        'amountPaid': 0,
        'amountDue': fees,
        'cashPayment': 0,
        'visaPayment': 0,
        'masterCardPayment': 0,
        'datePosted': DateTime.now().millisecondsSinceEpoch,
      });
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddDialog(List<CheckListModel> list) async {
    String _studentId="";
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
            _dueDate(BuildContext context) async {
              dueDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (dueDate != null && dueDate != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  _dueDateController.text = f.format(dueDate!).toString();
                  dueDateInMilli=dueDate!.millisecondsSinceEpoch;
                });
            }
            _fromDate(BuildContext context) async {
              fromDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (fromDate != null && fromDate != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  _fromDateController.text = f.format(fromDate!).toString();
                  fromDateInMilli=fromDate!.millisecondsSinceEpoch;
                });
            }
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
                              child: Text("Add Delivery",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Type",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(
                                      color: primaryColor,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: type,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    elevation: 16,
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        type = newValue!;
                                        _studentController.text="";
                                      });
                                    },
                                    items: <String>[
                                      'Student',
                                      'Department',
                                      'Teacher',
                                      'Employee'
                                    ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                )

                              ],
                            ),
                            SizedBox(height: 10,),
                            if(type=='Student')
                              Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Student",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _studentController,
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
                                                  child: Column(

                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(10),
                                                        child:TypeAheadField(

                                                          textFieldConfiguration: TextFieldConfiguration(
                                                            autofocus: false,
                                                            style: DefaultTextStyle.of(context).style,
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
                                                                borderSide:
                                                                BorderSide(color: primaryColor, width: 0.5),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(7.0),
                                                                borderSide: BorderSide(
                                                                  color: primaryColor,
                                                                  width: 0.5,
                                                                ),
                                                              ),
                                                              hintText: "Search",
                                                              hintStyle: TextStyle(color: Colors.grey),
                                                              floatingLabelBehavior:
                                                              FloatingLabelBehavior.always,
                                                            ),
                                                          ),
                                                          suggestionsCallback: (pattern) async {
                                                            List<StudentModel> suggestion = [];
                                                            await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
                                                              querySnapshot.docs.forEach((doc) {
                                                                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                                                if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase()))
                                                                  suggestion.add(model);
                                                              });
                                                            });
                                                            return suggestion;
                                                          },
                                                          itemBuilder: (context, StudentModel suggestion) {
                                                            return ListTile(
                                                              leading: CircleAvatar(
                                                                backgroundImage:
                                                                NetworkImage(suggestion.photo),
                                                              ),
                                                              title: Text(
                                                                "${suggestion.firstName} ${suggestion.lastName}",
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                              subtitle: Text(
                                                                suggestion.email,
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            );
                                                          },
                                                          onSuggestionSelected: (StudentModel suggestion) {
                                                            _studentController.text = "${suggestion.firstName} ${suggestion.lastName}";
                                                            _studentId = suggestion.id;
                                                            _parentId=suggestion.parentId;
                                                            _schoolId=suggestion.schoolId;
                                                            _departmentId=suggestion.departmentId;
                                                            _gradeId=suggestion.gradeId;
                                                            _departmentController.text=suggestion.department;
                                                            _gradeController.text=suggestion.grade;
                                                            _schoolController.text=suggestion.school;
                                                            _parentController.text=suggestion.parent;
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
                                                                    Text("No Students Added",style: TextStyle(color: Colors.black))

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
                                                                        _studentController.text="${data['firstName']} ${data['lastName']}";
                                                                        _studentId=document.reference.id;
                                                                        _parentId=data['parentId'];
                                                                        _parentController.text=data['parent'];
                                                                        _schoolId=data['schoolId'];
                                                                        _departmentId=data['departmentId'];
                                                                        _gradeId=data['gradeId'];
                                                                        _gradeController.text=data['grade'];
                                                                        _schoolController.text=data['school'];
                                                                        _departmentController.text=data['department'];
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    leading: CircleAvatar(
                                                                      radius: 25,
                                                                      backgroundImage: NetworkImage(data['photo']),
                                                                      backgroundColor: Colors.indigoAccent,
                                                                      foregroundColor: Colors.white,
                                                                    ),
                                                                    title: Text("${data['firstName']} ${data['lastName']}",style: TextStyle(color: Colors.black),),
                                                                    subtitle:  Text("${data['email']}",style: TextStyle(color: Colors.black),),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                    );
                                  },
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
                                      borderSide:
                                      BorderSide(color: primaryColor, width: 0.5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                  ),
                                ),

                              ],
                            )
                            else if(type=='Department')
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
                                                      stream: FirebaseFirestore.instance.collection('departments').snapshots(),
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
                                                                    _studentController.text="${data['name']}";
                                                                    _studentId=document.reference.id;
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
                                    controller: _studentController,
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
                              )
                            else if(type=='Teacher')
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Teacher",
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
                                                        stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
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
                                                                  Text("No Teacher Added",style: TextStyle(color: Colors.black))

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
                                                                      _studentController.text="${data['name']}";
                                                                      _studentId=document.reference.id;
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
                                      controller: _studentController,
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
                                )
                              else if(type=='Employee')
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Employee",
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
                                                          stream: FirebaseFirestore.instance.collection('employees').snapshots(),
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
                                                                    Text("No Employees Added",style: TextStyle(color: Colors.black))

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
                                                                        _studentController.text="${data['name']}";
                                                                        _studentId=document.reference.id;
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
                                        controller: _studentController,
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
                                  "Academic Year",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _academicYearController,
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
                            if(type=='Student')
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Fees From Date",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: (){
                                          _fromDate(context);
                                        },
                                        controller: _fromDateController,
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
                                        "Fees Due Date",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: (){
                                          _dueDate(context);
                                        },
                                        controller: _dueDateController,
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
                                ],
                              ),

                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Supply Items",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: MediaQuery.of(context).size.height*0.3,
                              decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (BuildContext context,int index){
                                  return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: CheckboxListTile(
                                        title: Text(list[index].model.name),
                                        value: list[index].check,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            list[index].check = value!;
                                          });
                                        },
                                      )
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 15,),
                            InkWell(
                              onTap: (){
                                print("tap");
                                int fee=0;
                                List<String> ids=[];
                                for(int i=0;i<list.length;i++){
                                  if(list[i].check)
                                    ids.add(list[i].model.id);
                                    fee+=int.parse(list[i].model.price.toString());
                                }
                                add(_studentId,ids,fee);
                              },
                              child: Container(
                                height: 50,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text("Add Delivery",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      ),


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
            Header("Supply Delivery",widget._scaffoldKey),
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
                            onPressed: () async{
                              List<CheckListModel> list=[];
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Please wait");
                              await FirebaseFirestore.instance
                                  .collection('supply_items')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                  setState(() {
                                    CheckListModel model=new CheckListModel(false,UniformItemModel.fromMap(data, doc.reference.id));
                                    list.add(model);
                                  });
                                });
                              });
                              pr.close();
                              final f = new DateFormat('dd-MM-yyyy');
                              _dueDateController.text = f.format(DateTime.now()).toString();
                              _fromDateController.text = f.format(DateTime.now()).toString();
                              _showAddDialog(list);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Delivery"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      SupplyDeliveryList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
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
