import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/uniform/uniform_attribute_model.dart';
import 'package:school_management_system/screens/uniform/uniform_attribute_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_attribute_value_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class UniformAttributeList extends StatefulWidget {
  const UniformAttributeList({Key? key}) : super(key: key);

  @override
  _UniformAttributeListState createState() => _UniformAttributeListState();
}


class _UniformAttributeListState extends State<UniformAttributeList> {




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
            "Attributes",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('uniform_attributes').snapshots(),
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
                      Text('No attributes are added'),
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
                      label: Text("Value"),
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
var _nameController=TextEditingController();

Future<void> _showEdit(BuildContext context,UniformAttributeModel model) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();

          _nameController.text=model.name;





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
              height: MediaQuery.of(context).size.height*0.4,
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
                            child: Text("Edit Attribute",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                "Name",
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



                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('uniform_attributes').doc(model.id).update({
                                'name': _nameController.text,

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
                              child: Text("Update Attribute",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  final model = UniformAttributeModel.fromSnapshot(data);
  return DataRow(
      cells: [
    DataCell(Text(model.name)),
        DataCell(
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AttributeValueScreen(model)));

            },
            child: Container(
              height: 50,
              width: 80,
              color: primaryColor,
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text("View",style: TextStyle(color: Colors.white),),
            ),
          )
        ),
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
                  title: 'Delete Attribute',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformAttributeScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('uniform_attributes').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformAttributeScreen())));
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


