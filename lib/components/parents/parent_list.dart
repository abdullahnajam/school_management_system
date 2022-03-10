import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/parent_model.dart';
import 'package:school_management_system/model/place/place_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/parent_screen.dart';
import 'package:school_management_system/screens/places/place_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class ParentList extends StatefulWidget {
  const ParentList({Key? key}) : super(key: key);

  @override
  _ParentListState createState() => _ParentListState();
}


class _ParentListState extends State<ParentList> {




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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Parents",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
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
                          List<ParentModel> suggestion = [];
                          await FirebaseFirestore.instance.collection('parents').get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                              ParentModel model = ParentModel.fromMap(data, doc.reference.id);
                              if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase()))
                                suggestion.add(model);
                            });
                          });
                          return suggestion;
                        },
                        itemBuilder: (context, ParentModel suggestion) {
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
                        onSuggestionSelected: (ParentModel suggestion) {
                          _showInfoDialog(suggestion, context);
                        },
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('parents').snapshots(),
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
                      Text('No parents are added'),
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
                      label: Text("Email"),
                    ),
                    DataColumn(
                      label: Text("Address"),
                    ),
                    DataColumn(
                      label: Text("Job"),
                    ),
                    DataColumn(
                      label: Text("Phone"),
                    ),
                    DataColumn(
                      label: Text("Photo"),
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

var _pefirstNameController=TextEditingController();
var _pelastNameController=TextEditingController();
var _pephoneController=TextEditingController();
var _peaddressController=TextEditingController();
var _ejobController=TextEditingController();


Future<void> _showInfoDialog(ParentModel model, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
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
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Parent Info",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .apply(color: secondaryColor),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children:[
                    Text(
                      "${model.firstName} ${model.lastName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.streetview,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          Text(
                            "   Address",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .apply(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        "${model.address}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .apply(color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          Text(
                            "   Job",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .apply(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        "${model.job}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .apply(color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          Text(
                            "   Phone",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .apply(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        "${model.phone}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .apply(color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          Text(
                            "   Status",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .apply(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        "${model.status}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .apply(color: Colors.black),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Children",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .apply(color: Colors.black),
                  ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('students')
                          .where("parentId", isEqualTo: model.id)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            margin: EdgeInsets.all(30),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.size == 0) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: Text("No children",
                                style: TextStyle(color: Colors.black)),
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
                                  label: Text("Name",
                                      style: TextStyle(color: Colors.black)),
                                ),
                                DataColumn(
                                  label: Text("School",
                                      style: TextStyle(color: Colors.black)),
                                ),
                                DataColumn(
                                  label: Text("Department",
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                              rows:
                              _buildStudentList(context, snapshot.data!.docs)),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
List<DataRow> _buildStudentList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildStudentListItem(context, data)).toList();
}

DataRow _buildStudentListItem(BuildContext context, DocumentSnapshot data) {
  final model = StudentModel.fromSnapshot(data);
  return DataRow(cells: [
    DataCell(Text("${model.firstName} ${model.lastName}", style: TextStyle(color: Colors.black))),
    DataCell(
        Text(model.school, maxLines: 1, style: TextStyle(color: Colors.black))),
    DataCell(Text("${model.department}", style: TextStyle(color: Colors.black))),
  ]);
}
Future<void> _showEditDialog(BuildContext context,ParentModel model) async {
  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri imageUri;
  bool imageUploading=false;
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setState){


          uploadToFirebase(File imageFile) async {
            final filePath = 'images/${DateTime.now()}.png';

            print("put");
            setState((){
              imageUploading=true;
              _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
            });

            fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
            imageUri = await taskSnapshot.ref.getDownloadURL();
            setState((){
              imageUrl=imageUri.toString();
              imageUploading=false;
              //imageUrl= "https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/bookingPics%2F1622649147001?alt=media&token=45a4483c-2f29-48ab-bcf1-813fd8fa304b";
              print(imageUrl);
            });

          }

          uploadImage() async {
            // HTML input element
            FileUploadInputElement uploadInput = FileUploadInputElement();
            uploadInput.click();

            uploadInput.onChange.listen(
                  (changeEvent) {
                final file = uploadInput.files!.first;
                final reader = FileReader();
                reader.readAsDataUrl(file);
                reader.onLoadEnd.listen(
                      (loadEndEvent) async {
                    uploadToFirebase(file);
                  },
                );
              },
            );
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
                            child: Text("Edit Parent Data",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "First Name",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        controller: _pefirstNameController,
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
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Last Name",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        controller: _pelastNameController,
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
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _pephoneController,
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
                                "Address",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              TextFormField(
                                minLines: 2,
                                maxLines: 2,
                                controller: _peaddressController,
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
                                "Job",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _ejobController,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 200,
                                width: 250,
                                child: imageUploading?Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Uploading",style: TextStyle(color: primaryColor),),
                                      SizedBox(width: 10,),
                                      CircularProgressIndicator()
                                    ],),
                                ):imageUrl==""?
                                Image.network(model.photo,height: 100,width: 100,fit: BoxFit.cover,)
                                    :Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,),
                              ),

                              InkWell(
                                onTap: (){
                                  uploadImage();
                                },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width*0.15,
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Text("Change Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('parents').doc(model.id).update({
                                'firstName': _pefirstNameController.text,
                                'lastName': _pelastNameController.text,
                                'phone': _pephoneController.text,
                                'job': _ejobController.text,
                                'photo':imageUrl==""?model.photo:imageUrl,
                                'address': _peaddressController.text,
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
                              child: Text("Update Parent Data",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  final model = ParentModel.fromSnapshot(data);
  return DataRow(
      onSelectChanged: (newValue) {
        _showInfoDialog(model, context);
      },
      cells: [
    DataCell(Text("${model.firstName} ${model.lastName}")),
    DataCell(Text(model.email)),
        DataCell(Text(model.address)),
        DataCell(Text(model.job)),
        DataCell(Text(model.phone)),
        DataCell(Image.network(model.photo,height: 50,width: 50,)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(model.status=="Active"?Icons.disabled_by_default:Icons.check_circle_outline),
              color: primaryColor,
              onPressed: (){

                FirebaseFirestore.instance.collection('parents').doc(model.id).update({
                  'status': model.status=="Active"?"Inactive":"Active",
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: primaryColor,
              onPressed: (){
                _showEditDialog(context,model);
              },
            ),
          ],
        )),

  ]);
}


