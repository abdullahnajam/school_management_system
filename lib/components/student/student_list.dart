import 'dart:html';
import 'dart:ui' as UI;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/student_detail_screen.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class StudentList extends StatefulWidget {
  String  classId;


  StudentList(this.classId);

  @override
  _StudentListState createState() => _StudentListState();
}


class _StudentListState extends State<StudentList> {

  String searchValue='Name';
  var _searchStudentController=TextEditingController();
  String _searchStudentId="";
  setSearchId(String id){
    setState(() {
      _searchStudentId=id;
    });
  }
  Future<void> _showSearchDialog() async {
    StudentModel? searchModel;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                height: MediaQuery.of(context).size.height*0.5,
                padding: EdgeInsets.all(20),
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
                            child: Text("Search Student",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: (){
                                Navigator.pop(context);

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Search By",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: searchValue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      searchValue = newValue!;
                                      _searchStudentController.text="";
                                      setSearchId("");
                                    });
                                  },
                                  items: <String>[
                                    'Name',
                                    'Email',
                                    'Phone'
                                  ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          if(searchValue=='Name')
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
                                      await FirebaseFirestore.instance.collection('students').where("classId",isEqualTo:widget.classId).get().then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                          StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                          if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase())) {
                                            suggestion.add(model);

                                          }
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
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentDetailScreen(suggestion)));

                                    },
                                  ),
                                ),
                              ],
                            )
                          else if(searchValue=='Email')
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
                                      await FirebaseFirestore.instance.collection('students').where("classId",isEqualTo:widget.classId).get().then((QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                          StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                          if ("${model.email}".toLowerCase().contains(pattern.toLowerCase()))
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
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentDetailScreen(suggestion)));

                                    },
                                  ),
                                ),
                              ],
                            )
                          else if(searchValue=='Phone')
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
                                          hintText: "Search by phone",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        List<StudentModel> suggestion = [];
                                        await FirebaseFirestore.instance.collection('students').where("classId",isEqualTo:widget.classId).get().then((QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                            StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                            if ("${model.phone}".toLowerCase().contains(pattern.toLowerCase()))
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
                                            suggestion.phone,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (StudentModel suggestion) {
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentDetailScreen(suggestion)));

                                      },
                                    ),
                                  ),
                                ],
                              ),
                          SizedBox(height: 10,),




                        ],
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
  }


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
                "Students",
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
                  _showSearchDialog();
                },
                icon: Icon(Icons.search),
                label: Text("Search"),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('students').where("classId",isEqualTo:widget.classId).snapshots(),
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
                      Text('No students are added'),
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
                      label: Text("Email"),
                    ),
                    DataColumn(
                      label: Text("Phone"),
                    ),
                    DataColumn(
                      label: Text("Address"),
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
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  var _firstNameController=TextEditingController();
  var _lastNameController=TextEditingController();
  var _phoneController=TextEditingController();
  var _addressController=TextEditingController();
  var _relationController=TextEditingController();


  var _schoolController=TextEditingController();
  var _departmentController=TextEditingController();
  var _gradeController=TextEditingController();
  var _classController=TextEditingController();
  var _parentController=TextEditingController();
  List<String> sids=[];
  bool isParentRegistered=false;

  Future<void> _showEdit(BuildContext context,StudentModel model) async {
    String imageUrl="";
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    bool imageUploading=false;
    int _step=0;
    String parentId=model.parentId;
    String _schoolId=model.schoolId,_departmentId=model.departmentId,gradeId=model.gradeId,classId=model.classId;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();

            _firstNameController.text=model.firstName;
            _lastNameController.text=model.lastName;
            _addressController.text=model.address;
            _phoneController.text=model.phone;
            _relationController.text=model.relation;

            _schoolController.text=model.school;
            _departmentController.text=model.department;
            _gradeController.text=model.grade;
            _classController.text=model.className;
            _parentController.text=model.parent;


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
                print("heer");
                imageUrl=imageUri.toString();
                imageUploading=false;
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
                              child: Text("Edit Student",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                          child: Stepper(
                            type: StepperType.horizontal,
                            controlsBuilder: (BuildContext context, ControlsDetails controls) {
                              return Row(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: controls.onStepContinue,
                                    child: _step==2?  Text('Update Student'):Text('Continue'),
                                  ),
                                  TextButton(
                                    onPressed: controls.onStepCancel,
                                    child: const Text('Back'),
                                  ),
                                ],
                              );
                            },
                            currentStep: _step,
                            onStepCancel: () {
                              if (_step > 0) {
                                setState(() { _step -= 1; });
                              }
                            },
                            onStepContinue: () {
                              if (_step < 2) {
                                setState(() { _step += 1; });
                                print("step continue $_step");
                              }
                              else if(_step==2){
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: "Adding");
                                FirebaseFirestore.instance.collection('students').doc(model.id).update({
                                  'firstName': _firstNameController.text,
                                  'lastName': _lastNameController.text,
                                  'phone': _phoneController.text,
                                  'address': _addressController.text,
                                  'school': _schoolController.text,
                                  'department': _departmentController.text,
                                  'grade': _gradeController.text,
                                  'className': _classController.text,
                                  'parent': _parentController.text,
                                  'relation': _relationController.text,
                                  'schoolId':_schoolId,
                                  'departmentId':_departmentId,
                                  'gradeId':gradeId,
                                  'classId':classId,
                                  'parentId':parentId,
                                  'photo':imageUrl==""?model.photo:imageUrl,
                                }).then((value) {
                                  pr.close();
                                  print("added");
                                  Navigator.pop(context);
                                });
                                //register(imageUrl,0,parentId,schoolId,departmentId,gradeId,classId,parentUrl);
                              }
                            },
                            onStepTapped: (int index) {
                              setState(() { _step = index; });
                            },
                            steps: <Step>[
                              Step(
                                isActive: _step >= 0?true:false,
                                state: _step >= 1 ? StepState.complete : StepState.disabled,
                                title: Text('Student Data'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                                  controller: _firstNameController,
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
                                                  controller: _lastNameController,
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
                                          controller: _phoneController,
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
                                          controller: _addressController,
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

                                  ],
                                ),
                              ),
                              Step(
                                  isActive: _step >= 1?true:false,
                                  state: _step >= 2 ? StepState.complete : StepState.disabled,
                                  title: Text('Assigning Fields'),
                                  content:Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
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
                                                                            _schoolId=document.reference.id;
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
                                            controller: _schoolController,
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
                                                                            _departmentController.text="${data['name']}";
                                                                            _departmentId=document.reference.id;
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
                                            controller: _departmentController,
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
                                            "Grade",
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
                                                              stream: FirebaseFirestore.instance.collection('grades').snapshots(),
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
                                                                        Text("No Grade Added",style: TextStyle(color: Colors.black))

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
                                                                            _gradeController.text="${data['name']}";
                                                                            gradeId=document.reference.id;
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
                                            controller: _gradeController,
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
                                            "Class",
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
                                                              stream: FirebaseFirestore.instance.collection('classes').snapshots(),
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
                                                                        Text("No Class Added",style: TextStyle(color: Colors.black))

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
                                                                            _classController.text="${data['name']}";
                                                                            classId=document.reference.id;
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
                                            controller: _classController,
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
                                    ],
                                  )
                              ),
                              Step(
                                  isActive: _step >= 2?true:false,
                                  state: _step >= 3 ? StepState.complete : StepState.disabled,
                                  title: Text('Parents'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Parent",
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
                                                              stream: FirebaseFirestore.instance.collection('parents').snapshots(),
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
                                                                        Text("No Parent Added",style: TextStyle(color: Colors.black))

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
                                                                            _parentController.text="${data['firstName']} ${data['lastName']}";
                                                                            parentId=document.reference.id;
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
                                            controller: _parentController,
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
                                            "Relation",
                                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                          ),
                                          TextFormField(
                                            controller: _relationController,
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
                                      SizedBox(height: 10,)

                                    ],
                                  )
                              ),
                            ],
                          )
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
    final model = StudentModel.fromSnapshot(data);
    return DataRow(
        onSelectChanged: (newValue) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentDetailScreen(model)));
        },
        cells: [
          DataCell(Text(model.uniqueId)),
          DataCell(Text("${model.firstName} ${model.lastName}")),
          DataCell(Text(model.email)),
          DataCell(Text(model.phone)),
          DataCell(Text(model.address,maxLines: 1,)),
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
                    title: 'Delete Student',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentScreen(widget.classId)));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('students').doc(model.id).delete().then((value) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentScreen(widget.classId))));
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

}


