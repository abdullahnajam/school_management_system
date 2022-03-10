import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/screens/academic/sub_department_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'department_list.dart';

class DepartmentDetailList extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;
  List<String> departmentIds;
  DepartmentDetailList(this._scaffoldKey,this.departmentIds);

  @override
  _DepartmentDetailListState createState() => _DepartmentDetailListState();
}

class _DepartmentDetailListState extends State<DepartmentDetailList> {

  /*var nameController=TextEditingController();
  var schoolController=TextEditingController();
  var departmentController=TextEditingController();
  var currentTermController=TextEditingController();
  var termsController=TextEditingController();

  add(String schoolId,departmentId) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('grades').add({
      'name': nameController.text,
      'school': schoolController.text,
      'department': departmentController.text,
      'totalTerms': termsController.text,
      'currentTerm': currentTermController.text,
      'schoolId': schoolId,
      'departmentId': departmentId,
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddDialog() async {
    String schoolId="",departmentId="";
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
                              child: Text("Add Grade",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                            "Grade",
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
                            "Number of terms",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            controller: termsController,
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
                            "Current Term",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            controller: currentTermController,
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
                          add(schoolId,departmentId);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Add Grade",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  }*/


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Grades",widget._scaffoldKey),
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
                          /*ElevatedButton.icon(
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
                            label: Text("Add Grades"),
                          ),*/
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Grades",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('grades').where("department",whereIn: widget.departmentIds).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container(
                                    margin: EdgeInsets.all(30),
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.data!.size==0){
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.all(80),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                                        Text('No grades are added'),
                                      ],
                                    ),
                                  );
                                }
                                print("size ${snapshot.data!.size}");
                                return new SizedBox(
                                  width: double.infinity,
                                  child: DataTable2(

                                      showCheckboxColumn: false,
                                      columnSpacing: defaultPadding,
                                      minWidth: 600,
                                      columns: [
                                        DataColumn(
                                          label: Text("Grade"),
                                        ),
                                        DataColumn(
                                          label: Text("School"),
                                        ),
                                        DataColumn(
                                          label: Text("Department"),
                                        ),
                                        DataColumn(
                                          label: Text("Total Terms"),
                                        ),
                                        DataColumn(
                                          label: Text("Current Term"),
                                        ),


                                        /*DataColumn(
                                          label: Text("Actions"),
                                        ),*/


                                      ],
                                      rows: _buildList(context, snapshot.data!.docs)

                                  ),
                                );
                              },
                            ),


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
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }
  /*var _nameController=TextEditingController();
  var _schoolController=TextEditingController();
  var _departmentController=TextEditingController();
  var _currentTermController=TextEditingController();
  var _termsController=TextEditingController();

  Future<void> _showEdit(BuildContext context,GradeModel model) async {
    String schoolId=model.schoolId;
    String departmentId=model.departmentId;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();

            _nameController.text=model.name;
            _schoolController.text=model.school;
            _departmentController.text=model.department;
            _currentTermController.text=model.currentTerm;
            _termsController.text=model.totalTerms;





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
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.9,
                width: MediaQuery.of(context).size.width*0.5,
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
                              child: Text("Edit Grade",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                  "Grade",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _nameController,
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
                                                                  _schoolController.text="${data['name']}";
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
                                  "Number of terms",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: termsController,
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
                                  "Current Term",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: currentTermController,
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
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: "Adding");
                                FirebaseFirestore.instance.collection('grades').doc(model.id).update({
                                  'name': nameController.text,
                                  'school': schoolController.text,
                                  'department': departmentController.text,
                                  'totalTerms': termsController.text,
                                  'currentTerm': currentTermController.text,
                                  'schoolId': schoolId,
                                  'departmentId': departmentId,
                                }).then((value) {
                                  pr.close();
                                  print("added");
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                height: 50,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text("Update Grade",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  }*/

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    final model = GradeModel.fromSnapshot(data);
    return DataRow(
        cells: [
          DataCell(Text(model.name)),
          DataCell(Text(model.school)),
          DataCell(Text(model.department)),
          DataCell(Text(model.totalTerms)),
          DataCell(Text(model.currentTerm)),
          /*DataCell(Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete_forever),
                color: primaryColor,
                onPressed: (){
                  AwesomeDialog(
                    dialogBackgroundColor: Colors.white,
                    width: MediaQuery.of(context).size.width*0.3,
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Delete Grade',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SubDepartmentScreen(widget.departmentIds)));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('grades').doc(model.id).delete().then((value) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SubDepartmentScreen(widget.departmentIds))));
                    },
                  )..show();
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: primaryColor,
                onPressed: (){
                  _showEdit(context,model);
                },
              ),
            ],
          )),*/

        ]);
  }

}
