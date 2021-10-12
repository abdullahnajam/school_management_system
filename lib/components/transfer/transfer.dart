import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/screens/transfer_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';



class Transfer extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Transfer(this._scaffoldKey);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {

  var _oldClassController=TextEditingController();
  var _newClassController=TextEditingController();
  var _oldDepartmentController=TextEditingController();
  String _oldDepartmentId="";
  String _oldClassId="";
  String _newClassId="";
  int totalNewStudents=0;
  bool showNewStudentCount=false;
  bool showOldStudentCount=false;
  int totalOldStudents=0;
  getStudentCount() async{
    int oldCount=0;
    int newCount=0;
    await FirebaseFirestore.instance.collection('students').where("departmentId",isEqualTo:_oldDepartmentId)
        .where("classId",isEqualTo:_oldClassId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          oldCount++;
        });
      });
    });
    await FirebaseFirestore.instance
        .collection('students').where("departmentId",isEqualTo:_oldDepartmentId)
        .where("classId",isEqualTo:_newClassId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          newCount++;
        });
      });
    });
    setState(() {
      totalOldStudents=oldCount;
      totalNewStudents=newCount;
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Transfer",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [

                      SizedBox(height: defaultPadding),
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transfer to new classes",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(height: defaultPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
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
                                                                            _oldDepartmentController.text="${data['name']}";
                                                                            _oldDepartmentId=document.reference.id;
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
                                            controller: _oldDepartmentController,
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
                                      SizedBox(height: defaultPadding,),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Old Class",
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
                                                              stream: FirebaseFirestore.instance.collection('classes')
                                                                  .where("departmentId",isEqualTo:_oldDepartmentId).snapshots(),
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
                                                                        Text("No Classes Added",style: TextStyle(color: Colors.black))

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
                                                                            _oldClassController.text="${data['name']}";
                                                                            _oldClassId=document.reference.id;
                                                                            setState(() {
                                                                             showOldStudentCount=true;
                                                                            });
                                                                            getStudentCount();
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
                                            controller: _oldClassController,
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
                                      SizedBox(height: defaultPadding,),
                                      showOldStudentCount?Text(
                                        "Total Students : $totalOldStudents",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ):Container(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
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
                                                                            _oldDepartmentController.text="${data['name']}";
                                                                            _oldDepartmentId=document.reference.id;
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
                                            controller: _oldDepartmentController,
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
                                      SizedBox(height: defaultPadding,),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "New Class",
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
                                                              stream: FirebaseFirestore.instance.collection('classes')
                                                                  .where("departmentId",isEqualTo:_oldDepartmentId).snapshots(),
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
                                                                        Text("No Classes Added",style: TextStyle(color: Colors.black))

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
                                                                            _newClassController.text="${data['name']}";
                                                                            _newClassId=document.reference.id;
                                                                            setState(() {
                                                                              showNewStudentCount=true;
                                                                            });
                                                                            getStudentCount();
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
                                            controller: _newClassController,
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
                                      SizedBox(height: defaultPadding,),
                                      showNewStudentCount?Text(
                                        "Total Students : $totalNewStudents",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ):Container(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: defaultPadding),
                            Center(
                              child: InkWell(
                                onTap: ()async{
                                  final ProgressDialog pr = ProgressDialog(context: context);
                                  pr.show(max:0,msg: "Transferring");
                                  await FirebaseFirestore.instance.collection('students').where("departmentId",isEqualTo:_oldDepartmentId)
                                      .where("classId",isEqualTo:_oldClassId)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      FirebaseFirestore.instance.collection('students').doc(doc.reference.id).update({
                                        'classId': _newClassId,

                                      }).then((value) {
                                        getStudentCount();
                                        pr.close();
                                        AwesomeDialog(
                                          dialogBackgroundColor: Colors.white,
                                          width:Responsive.isMobile(context)?MediaQuery.of(context).size.width*0.7:MediaQuery.of(context).size.width*0.3,
                                          context: context,
                                          dialogType: DialogType.SUCCES,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Students Transferred',
                                          desc: 'The data is successfully transferred to another class',

                                          btnOkOnPress: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TransferScreen()));
                                          },
                                        )..show();
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.5,
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Text("Transfer",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              ),
                            )


                          ],
                        ),
                      ),
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
