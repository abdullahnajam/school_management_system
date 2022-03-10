import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/components/uniform_center/uniform_delivery/uniform_delivery_list.dart';
import 'package:school_management_system/model/checklist_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/model/uniform/uniform_category_model.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/screens/uniform/uniform_add_delivery.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;



class UniformDelivery extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  UniformDelivery(this._scaffoldKey);

  @override
  _UniformDeliveryState createState() => _UniformDeliveryState();
}

class _UniformDeliveryState extends State<UniformDelivery> {

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

  DateTime? dueDate,fromDate;
  int dueDateInMilli=DateTime.now().millisecondsSinceEpoch;
  int fromDateInMilli=DateTime.now().millisecondsSinceEpoch;


  add(String _studentId,List _itemId,int fees) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('uniform_deliveries').add({
      'student': _studentController.text,
      'item': _itemId,
      'studentId': _studentId,
      'status': "Pending",
      'payment': "Not Paid",
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      FirebaseFirestore.instance.collection('fees').add({
        'student': _studentController.text,
        'itemId': value.id,
        'school': _schoolController.text,
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
        'feeCategory': "Uniform Fees",
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
      }).then((value) {
        pr.close();
        print("added");
        Navigator.pop(context);
      });
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
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Uniform Items",
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
            Header("Uniform Delivery",widget._scaffoldKey),
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
                              List<String> list=[];
                              list.add("All Categories");
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Please wait");
                              await FirebaseFirestore.instance
                                  .collection('uniform_categories')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                                  setState(() {
                                    list.add(UniformCategoryModel.fromMap(data, doc.reference.id).name);
                                  });
                                });
                              });
                              pr.close();
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UniformAddDeliveryScreen(list)));

                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Delivery"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      UniformDeliveryList(),
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
