import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/book_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/uniform/uniform_Delivery_model.dart';
import 'package:school_management_system/screens/uniform/uniform_delivery_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class UniformDeliveryList extends StatefulWidget {
  const UniformDeliveryList({Key? key}) : super(key: key);

  @override
  _UniformDeliveryListState createState() => _UniformDeliveryListState();
}


class _UniformDeliveryListState extends State<UniformDeliveryList> {




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
            "Deliveries",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('uniform_deliveries').snapshots(),
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
                      Text('No Deliveries are added'),
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
                      label: Text("Item"),
                    ),
                    DataColumn(
                      label: Text("Status"),
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
var _studentController=TextEditingController();

Future<void> _showEdit(BuildContext context,UniformDeliveryModel model) async {
  String _studentId=model.studentId;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();

          _studentController.text=model.student;





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
                            child: Text("Edit Delivery",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                                            Text("No Student Added",style: TextStyle(color: Colors.black))

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



                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('uniform_deliveries').doc(model.id).update({
                                'student': _studentController.text,
                                'studentId': _studentId,
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
                              child: Text("Update Delivery",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
Future<void> _showChangeStatusDialog(UniformDeliveryModel model,BuildContext context) async {
  return showDialog<void>(
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
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Change Status",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                  SizedBox(height: 10,),
                  ListTile(
                    onTap: (){
                      var width;
                      if(Responsive.isMobile(context)){
                        width=MediaQuery.of(context).size.width*0.8;
                      }
                      else if(Responsive.isTablet(context)){
                        width=MediaQuery.of(context).size.width*0.6;
                      }
                      else if(Responsive.isDesktop(context)){
                        width=MediaQuery.of(context).size.width*0.3;
                      }
                      AwesomeDialog(
                        width: width,
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        dialogBackgroundColor: secondaryColor,
                        title: 'Change Status',
                        desc: 'Are you sure you want to change status?',
                        btnCancelOnPress: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));
                        },
                        btnOkOnPress: () {
                          FirebaseFirestore.instance.collection('uniform_deliveries').doc(model.id).update({
                            'status':"Pending"
                          }).then((value) {

                            Navigator.pop(context);

                          }).onError((error, stackTrace) {
                            var width;
                            if(Responsive.isMobile(context)){
                              width=MediaQuery.of(context).size.width*0.8;
                            }
                            else if(Responsive.isTablet(context)){
                              width=MediaQuery.of(context).size.width*0.6;
                            }
                            else if(Responsive.isDesktop(context)){
                              width=MediaQuery.of(context).size.width*0.3;
                            }
                            AwesomeDialog(
                              width: width,
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogBackgroundColor: secondaryColor,
                              title: 'Error : Unable to change status',
                              desc: '${error.toString()}',

                              btnOkOnPress: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));

                              },
                            )..show();
                          });
                        },
                      )..show();

                    },
                    title: Text("Pending",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      var width;
                      if(Responsive.isMobile(context)){
                        width=MediaQuery.of(context).size.width*0.8;
                      }
                      else if(Responsive.isTablet(context)){
                        width=MediaQuery.of(context).size.width*0.6;
                      }
                      else if(Responsive.isDesktop(context)){
                        width=MediaQuery.of(context).size.width*0.3;
                      }
                      AwesomeDialog(
                        width: width,
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        dialogBackgroundColor: secondaryColor,
                        title: 'Change Status',
                        desc: 'Are you sure you want to change status?',
                        btnCancelOnPress: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));
                        },
                        btnOkOnPress: () {
                          FirebaseFirestore.instance.collection('uniform_deliveries').doc(model.id).update({
                            'status':"Ready to deliver"
                          }).then((value) {

                            Navigator.pop(context);

                          }).onError((error, stackTrace) {
                            var width;
                            if(Responsive.isMobile(context)){
                              width=MediaQuery.of(context).size.width*0.8;
                            }
                            else if(Responsive.isTablet(context)){
                              width=MediaQuery.of(context).size.width*0.6;
                            }
                            else if(Responsive.isDesktop(context)){
                              width=MediaQuery.of(context).size.width*0.3;
                            }
                            AwesomeDialog(
                              width: width,
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogBackgroundColor: secondaryColor,
                              title: 'Error : Unable to change status',
                              desc: '${error.toString()}',

                              btnOkOnPress: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));

                              },
                            )..show();
                          });
                        },
                      )..show();

                    },
                    title: Text("Ready to deliver",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      var width;
                      if(Responsive.isMobile(context)){
                        width=MediaQuery.of(context).size.width*0.8;
                      }
                      else if(Responsive.isTablet(context)){
                        width=MediaQuery.of(context).size.width*0.6;
                      }
                      else if(Responsive.isDesktop(context)){
                        width=MediaQuery.of(context).size.width*0.3;
                      }
                      AwesomeDialog(
                        width: width,
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        dialogBackgroundColor: secondaryColor,
                        title: 'Change Status',
                        desc: 'Are you sure you want to change status?',
                        btnCancelOnPress: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));
                        },
                        btnOkOnPress: () {
                          FirebaseFirestore.instance.collection('uniform_deliveries').doc(model.id).update({
                            'status':"Delivered"
                          }).then((value) {

                            Navigator.pop(context);

                          }).onError((error, stackTrace) {
                            var width;
                            if(Responsive.isMobile(context)){
                              width=MediaQuery.of(context).size.width*0.8;
                            }
                            else if(Responsive.isTablet(context)){
                              width=MediaQuery.of(context).size.width*0.6;
                            }
                            else if(Responsive.isDesktop(context)){
                              width=MediaQuery.of(context).size.width*0.3;
                            }
                            AwesomeDialog(
                              width: width,
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogBackgroundColor: secondaryColor,
                              title: 'Error : Unable to change status',
                              desc: '${error.toString()}',

                              btnOkOnPress: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));

                              },
                            )..show();
                          });
                        },
                      )..show();

                    },
                    title: Text("Delivered",style: TextStyle(color: Colors.black),),
                  ),


                ],
              ),
            ),
          );
        },
      );
    },
  );
}
DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = UniformDeliveryModel.fromSnapshot(data);
  return DataRow(
      cells: [
    DataCell(Text(model.student)),
        DataCell(Text(model.item.length.toString())),
        DataCell(Text(model.status,maxLines: 1),onTap: (){
          _showChangeStatusDialog(model, context);
        }),
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
                  title: 'Delete Delivery',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('uniform_deliveries').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen())));
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


