import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/employee_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}


class _EmployeeListState extends State<EmployeeList> {




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
            "Employees",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('employees').snapshots(),
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
                      Text('No employees are added'),
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
                      label: Text("Code"),
                    ),
                    DataColumn(
                      label: Text("Name"),
                    ),

                    DataColumn(
                      label: Text("School"),
                    ),
                    DataColumn(
                      label: Text("Department"),
                    ),
                    DataColumn(
                      label: Text("Category"),
                    ),
                    DataColumn(
                      label: Text("National Id"),
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
var nameController=TextEditingController();
var schoolController=TextEditingController();
var departmentController=TextEditingController();
var _categoryController=TextEditingController();
var _nationalIdController=TextEditingController();

Future<void> _showEdit(BuildContext context,EmployeeModel model) async {
  String schoolId=model.schoolId;
  String departmentId=model.departmentId;
  String _categoryId=model.categoryId;
  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri imageUri;
  bool imageUploading=false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();

          nameController.text=model.name;
          schoolController.text=model.school;
          _categoryController.text=model.category;
          departmentController.text=model.department;
          _nationalIdController.text=model.nationalId;


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
                            child: Text("Edit Employee",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                "Class Name",
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
                                "Category",
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
                                                  stream: FirebaseFirestore.instance.collection('employee_categories').snapshots(),
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
                                                            Text("No Category Added",style: TextStyle(color: Colors.black))

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
                                                                _categoryController.text="${data['name']}";
                                                                _categoryId=document.reference.id;
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
                                controller: _categoryController,
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
                                "National Id",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _nationalIdController,
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
                                  child: Text("Change Logo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              )
                            ],
                          ),




                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Adding");
                              FirebaseFirestore.instance.collection('employees').doc(model.id).update({
                                'name': nameController.text,
                                'school': schoolController.text,
                                'department': departmentController.text,
                                'category': _categoryController.text,
                                'photo': imageUrl==""?model.photo:imageUrl,
                                'nationalId': _nationalIdController.text,
                                'schoolId': schoolId,
                                'categoryId': _categoryId,
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
                              child: Text("Update Employee",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  final model = EmployeeModel.fromSnapshot(data);
  return DataRow(
      cells: [
    DataCell(Text(model.uniqueId)),
        DataCell(Text(model.name)),
    DataCell(Text(model.school)),
        DataCell(Text(model.department)),
        DataCell(Text(model.category)),
        DataCell(Text(model.nationalId.toString())),
        DataCell(Image.network(model.photo,height: 50,width: 50,)),
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
                  title: 'Delete Employee',
                  desc: 'Are you sure you want to delete this record?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmployeeScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('employees').doc(model.id).delete().then((value) =>
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmployeeScreen())));
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


