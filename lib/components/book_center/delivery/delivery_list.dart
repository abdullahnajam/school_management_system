import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/book_delivery_model.dart';
import 'package:school_management_system/model/book_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/books/book_delivery_screen.dart';
import 'package:school_management_system/screens/books/book_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class BookDeliveryList extends StatefulWidget {
  const BookDeliveryList({Key? key}) : super(key: key);

  @override
  _BookDeliveryListState createState() => _BookDeliveryListState();
}


class _BookDeliveryListState extends State<BookDeliveryList> {




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
            "Book Deliveries",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('book_delivery').snapshots(),
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
                      Text('No delivery are scheduled'),
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
                      label: Text("Name"),
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
Future<void> _showEdit(BuildContext context,BookDeliveryModel model) async {
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
                            child: Text("Edit Book Delivery",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                                                      _studentController.text="${data['firstName']} ${data['lastName']}";
                                                                      _studentId=document.reference.id;
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



                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('book_delivery').doc(model.id).update({
                                'student':_studentController.text,
                                'studentId':_studentId,
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
                              child: Text("Update Delivery Information",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  final model = BookDeliveryModel.fromSnapshot(data);
  return DataRow(
      cells: [
    DataCell(Text(model.student)),
    //DataCell(Text(model.subject)),

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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookDeliveryScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('book_delivery').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookDeliveryScreen())));
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


