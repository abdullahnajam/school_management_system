import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'department_list.dart';

class Departments extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Departments(this._scaffoldKey);

  @override
  _DepartmentsState createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {

  var nameController=TextEditingController();
  var schoolNameController=TextEditingController();
  var mainDepartmentNameController=TextEditingController();
  bool isSub=false;

  add(String id,subId) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('departments').add({

      'schoolName': schoolNameController.text,
      'name': nameController.text,
      'schoolId': id,
      'mainDepartmentName': isSub?mainDepartmentNameController.text:"none",
      'mainDepartmentId': subId,
      'isSubDepartment': isSub,
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddDialog() async {
    String schoolId="";
    String _mainDepartmentId="none";
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
                height: MediaQuery.of(context).size.height*0.7,
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
                              child: Text("Add Department",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                  "Department Name",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: nameController,
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
                                                              Text("No Schools Added",style: TextStyle(color: Colors.black))

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
                                                                  schoolNameController.text="${data['name']}";
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
                                  controller: schoolNameController,
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
                            CheckboxListTile(
                              title: const Text('Sub Department',style: TextStyle(color: Colors.black),),
                              value: isSub,
                              onChanged: (bool? value) {
                                setState(() {
                                  isSub = value!;
                                });
                              },
                              secondary: const Icon(Icons.subdirectory_arrow_left,color: Colors.black,),
                            ),
                            SizedBox(height: 10,),
                            isSub?
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Main Department",
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
                                                        .where("isSubDepartment",isEqualTo: false).snapshots(),
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
                                                                  mainDepartmentNameController.text="${data['name']}";
                                                                  _mainDepartmentId=document.reference.id;
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
                                  controller: mainDepartmentNameController,
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
                            ):Container(),


                            SizedBox(height: 15,),
                            InkWell(
                              onTap: (){
                                print("tap");

                                if (_formKey.currentState!.validate()) {
                                  add(schoolId,_mainDepartmentId);
                                }
                              },
                              child: Container(
                                height: 50,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text("Add Department",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                              ),
                            )
                          ],
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
            Header("Departments",widget._scaffoldKey),
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
                            label: Text("Add Departments"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      DepartmentList(),
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
