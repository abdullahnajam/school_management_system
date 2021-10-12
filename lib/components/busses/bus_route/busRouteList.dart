import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/bus/bus_line_model.dart';
import 'package:school_management_system/model/bus/bus_model.dart';
import 'package:school_management_system/model/bus/bus_setup_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/bus/bus_line_screen.dart';
import 'package:school_management_system/screens/bus/bus_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class BusRouteList extends StatefulWidget {
  const BusRouteList({Key? key}) : super(key: key);

  @override
  _BusRouteListState createState() => _BusRouteListState();
}


class _BusRouteListState extends State<BusRouteList> {




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bus Route",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('bus_route').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                    Text('Something went wrong'),
                  ],
                );
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
                      Text('No bus route are added'),
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
                      label: Text("Student"),
                    ),
                    DataColumn(
                      label: Text("Order"),
                    ),
                    DataColumn(
                      label: Text("Bus"),
                    ),
                    DataColumn(
                      label: Text("Driver"),
                    ),
                    DataColumn(
                      label: Text("Coordinator"),
                    ),
                    DataColumn(
                      label: Text("Line"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),


                  ],
                  rows: _buildList(context, snapshot.data!.docs)

                ),
              );
            },
          ),


        ],
      ),
    );
  }
}
List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return  snapshot.map((data) => _buildListItem(context, data)).toList();
}
var _orderController=TextEditingController();

var _driverController=TextEditingController();
var _lineController=TextEditingController();
var _coordinatorController=TextEditingController();
var _busController=TextEditingController();

var _studentController=TextEditingController();
var _addressController=TextEditingController();

Future<void> _showEdit(BuildContext context,BusSetUpModel model) async {
  String _lineId=model.lineId;
  String _busId=model.busId;
  String _driverId=model.driverId;
  String _coordinatorId=model.coordinatorId;
  //String _studentId=model.studentId;

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();

          _orderController.text=model.order.toString();
          _driverController.text=model.driver.toString();
          _coordinatorController.text=model.coordinator;

          /*_studentController.text=model.student.toString();
          _addressController.text=model.studentAddress.toString();*/
          _busController.text=model.busNumber;
          _lineController.text=model.line;







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
                            child: Text("Edit Bus Line",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                "Order of pickup",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _orderController,
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
                                "Bus",
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
                                                  stream: FirebaseFirestore.instance.collection('busses').snapshots(),
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
                                                            Text("No busses Added",style: TextStyle(color: Colors.black))

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
                                                                _busController.text="${data['busNumber']}";
                                                                _busId=document.reference.id;
                                                              });
                                                              Navigator.pop(context);
                                                            },

                                                            title: Text("${data['busNumber']}",style: TextStyle(color: Colors.black),),
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
                                controller: _busController,
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
                                "Bus Line",
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
                                                  stream: FirebaseFirestore.instance.collection('bus_lines').snapshots(),
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
                                                            Text("No Bus Line Added",style: TextStyle(color: Colors.black))

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
                                                                _lineController.text="${data['name']}";
                                                                _lineId=document.reference.id;
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
                                controller: _lineController,
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
                                "Bus Driver",
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
                                                  stream: FirebaseFirestore.instance.collection('bus_driver').snapshots(),
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
                                                            Text("No Bus Driver Added",style: TextStyle(color: Colors.black))

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
                                                                _driverController.text="${data['name']}";
                                                                _driverId=document.reference.id;
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
                                controller: _driverController,
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
                                "Bus Coordinator",
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
                                                  stream: FirebaseFirestore.instance.collection('bus_coordinators').snapshots(),
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
                                                            Text("No Bus Coordinator Added",style: TextStyle(color: Colors.black))

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
                                                                _coordinatorController.text="${data['name']}";
                                                                _coordinatorId=document.reference.id;
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
                                controller: _coordinatorController,
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
                              FirebaseFirestore.instance.collection('bus_route').doc(model.id).update({
                                'busId': _busId,
                                'busNumber': _busController.text,
                                'driver': _driverController.text,
                                'driverId': _driverId,
                                'coordinator': _coordinatorController.text,
                                'coordinatorId': _coordinatorId,
                                'line': _lineController.text,
                                'lineId': _lineId,
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
                              child: Text("Update Bus Line",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = BusSetUpModel.fromSnapshot(data);
  return DataRow(
      cells: [
    DataCell(Text("${model.students.length} Students"),onTap: ()async{
      List<StudentModel> students=[];
      final ProgressDialog pr = ProgressDialog(context: context);
      pr.show(max: 100, msg: "Please wait");
      await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          if(model.students.contains(doc.reference.id))
            students.add(StudentModel.fromMap(data, doc.reference.id));
        });
      });

      pr.close();
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {

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
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width*0.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Students",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(students[index].photo),
                                    backgroundColor: Colors.indigoAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text("${students[index].firstName} ${students[index].lastName}"),
                                  subtitle: Text(students[index].address,maxLines: 1,),

                                )
                            );
                          },
                        ),
                      )

                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }),
    DataCell(Text(model.order.toString())),
        DataCell(Text(model.busNumber.toString())),
        DataCell(Text(model.driver.toString())),
        DataCell(Text(model.coordinator.toString())),
        DataCell(Text(model.line.toString())),
        DataCell(Row(
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
                  title: 'Delete Bus Route',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusLineScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('bus_route').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusLineScreen())));
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
        )),

  ]);
}


