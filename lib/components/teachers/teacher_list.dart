import 'dart:html';
import 'dart:ui' as UI;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/school_model.dart';
import 'package:school_management_system/model/subject_model.dart';
import 'package:school_management_system/model/teacherModel_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/teacher_detail_screen.dart';
import 'package:school_management_system/screens/teacher_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  _TeacherListState createState() => _TeacherListState();
}


class _TeacherListState extends State<TeacherList> {




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
            "Teacher",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
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
                      Text('No teachers are added'),
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
                      label: Text("Subjects"),
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
  var _nameController=TextEditingController();
  var _phoneController=TextEditingController();
  var _addressController=TextEditingController();

  var _nationalIdController=TextEditingController();
  var _bloodTypeController=TextEditingController();

  var schoolController=TextEditingController();
  var departmentController=TextEditingController();
  var _lessonController=TextEditingController();
  var _staffController=TextEditingController();

  List<_TeacherCheckList> schools=[];
  List<_TeacherCheckList> departments=[];
  List<_TeacherCheckList> subjects=[];

  Future<void> _showEdit(BuildContext context,TeacherModel model) async {
    List schoolId=model.schools;
    List departmentId=model.departments;
    List subjectId=model.subjects;
    String staffId=model.staffId;
    List<_TeacherCheckList> tempDepartments=departments;
    List<_TeacherCheckList> tempSub=subjects;
    String imageUrl=model.photo;
    bool assignDuty=model.assignDuty;
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    int _step = 0;
    bool imageUploading=false;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();

            _nameController.text=model.name;
            _phoneController.text=model.phone;
            _staffController.text=model.staff;
            _lessonController.text=model.lessonCapacity.toString();
            _addressController.text=model.address;
            _nationalIdController.text=model.nationalId.toString();
            _bloodTypeController.text=model.bloodType.toString();



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
                              child: Text("Edit Teacher",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                        child:Stepper(
                          type: StepperType.horizontal,
                          controlsBuilder: (BuildContext context, ControlsDetails controls) {
                            return Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: controls.onStepContinue,
                                  child: _step==3?  Text('Update Teacher'):Text('Continue'),
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
                            if (_step < 3) {
                              if(_step==1){
                                setState(() {
                                  tempDepartments=[];
                                });
                                departments.forEach((element) {
                                  schools.forEach((schoolSelected) {
                                    if(schoolSelected.check && schoolSelected.model.name==element.model.schoolName){
                                      setState(() {
                                        tempDepartments.add(element);
                                      });
                                    }
                                  });
                                });
                              }
                              if(_step==2){
                                setState(() {
                                  tempSub=[];
                                });
                                subjects.forEach((element) {
                                  departments.forEach((depSelected) {
                                    if(depSelected.check && depSelected.model.name==element.model.department){
                                      setState(() {
                                        tempSub.add(element);
                                      });
                                    }
                                  });
                                });
                              }
                              setState(() { _step += 1; });
                              print("step continue $_step");
                            }
                            else if(_step==3){
                              final ProgressDialog pr = ProgressDialog(context: context);
                              pr.show(max: 100, msg: "Loading");
                              List schoolIds=[];
                              List departmentIds=[];
                              List subjectIds=[];
                              for(int i=0;i<schools.length;i++){
                                if(schools[i].check)
                                  schoolIds.add(schools[i].model.id);
                              }
                              for(int i=0;i<departments.length;i++){
                                if(departments[i].check)
                                  departmentIds.add(departments[i].model.id);
                              }
                              for(int i=0;i<subjects.length;i++){
                                if(subjects[i].check)
                                  subjectIds.add(subjects[i].model.id);
                              }
                              FirebaseFirestore.instance.collection('teachers').doc(model.id).update({
                                'name': _nameController.text,
                                'phone': _phoneController.text,
                                'address': _addressController.text,
                                'schools': schoolIds,
                                'departments': departmentIds,
                                'subjects': subjectIds,
                                'photo':imageUrl,
                                'staff': _staffController.text,
                                'staffId':staffId,
                                'assignDuty':assignDuty,
                                'lessonCapacity': int.parse(_lessonController.text),
                                'nationalId': _nationalIdController.text,
                                'bloodType': _bloodTypeController.text,

                              }).then((value) {
                                pr.close();
                                print("added");
                                Navigator.pop(context);
                              });
                            }
                          },
                          onStepTapped: (int index) {
                            setState(() { _step = index; });
                          },
                          steps: <Step>[
                            Step(
                              isActive: _step >= 0?true:false,
                              state: _step >= 1 ? StepState.complete : StepState.disabled,
                              title: Text('Teacher Data'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "National ID",
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
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Blood Type",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        minLines: 2,
                                        maxLines: 2,
                                        controller: _bloodTypeController,
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
                                        "Lesson Capacity",
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        controller: _lessonController,
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

                                    title: const Text('Assign Duty',style: TextStyle(color: Colors.black),),
                                    value: assignDuty,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        assignDuty = value!;
                                      });
                                    },
                                    secondary: const Icon(Icons.work,color: Colors.black,),
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
                                                          stream: FirebaseFirestore.instance.collection('departments')
                                                              .where('schoolName',isEqualTo:schoolController.text).snapshots(),
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
                                        "Staff",
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
                                                          stream: FirebaseFirestore.instance.collection('staff')
                                                              .where('department',isEqualTo:departmentController.text).snapshots(),
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
                                                                    Text("No Staff Added",style: TextStyle(color: Colors.black))

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
                                                                        _staffController.text="${data['name']}";
                                                                        staffId=document.reference.id;
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
                                        controller: _staffController,
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
                                        height: 100,
                                        width: 150,
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
                                        Image.asset("assets/images/placeholder.png",height: 100,width: 150,fit: BoxFit.cover,)
                                            :Image.network(imageUrl,height: 100,width: 150,fit: BoxFit.cover,),
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
                                          child: Text("Add Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),

                                ],
                              ),
                            ),
                            Step(
                              isActive: _step >= 1?true:false,
                              state: _step >= 2 ? StepState.complete : StepState.disabled,
                              title: Text('Schools'),
                              content: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: schools.length,
                                  itemBuilder: (context,int i){
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CheckboxListTile(
                                          title: Text(schools[i].model.name),
                                          value: schools[i].check,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              schools[i].check = value!;
                                            });
                                          },
                                        )
                                    );
                                  },
                                ),
                              ),
                            ),
                            Step(
                              isActive: _step >= 2?true:false,
                              state: _step >= 3 ? StepState.complete : StepState.disabled,
                              title: Text('Departments'),
                              content: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tempDepartments.length,
                                  itemBuilder: (context,int i){
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CheckboxListTile(
                                          title: Text(tempDepartments[i].model.name),
                                          value: tempDepartments[i].check,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              tempDepartments[i].check = value!;
                                            });
                                          },
                                        )
                                    );
                                  },
                                ),
                              ),
                            ),
                            Step(
                              isActive:_step >= 3?true:false,
                              state: _step >= 4 ? StepState.complete : StepState.disabled,
                              title: Text('Subjects'),
                              content:Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tempSub.length,
                                  itemBuilder: (context,int i){
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CheckboxListTile(
                                          title: Text(tempSub[i].model.name),
                                          value: tempSub[i].check,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              tempSub[i].check = value!;
                                            });
                                          },
                                        )
                                    );
                                  },
                                ),
                              ),
                            ),
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
    final model = TeacherModel.fromSnapshot(data);
    return DataRow(
        onSelectChanged: (newValue) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherDetailScreen(model)));
        },
        cells: [
          DataCell(Text(model.uniqueId)),
          DataCell(Text(model.name)),
          DataCell(Text(model.email)),
          DataCell(Text(model.phone)),
          DataCell(Text("View"),
          onTap: ()async{
            List<String> subjects=[];

            await FirebaseFirestore.instance
                .collection('subjects')
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                if(model.subjects.contains(doc.reference.id))
                  subjects.add(doc["name"]);
              });
            });
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
                                child:Text("Subjects")
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: subjects.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return Text(subjects[index]);
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
          }),


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
                    title: 'Delete Teacher',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('teachers').doc(model.id).delete().then((value) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen())));
                    },
                  )..show();
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: primaryColor,
                onPressed: ()async{
                  schools=[];
                  departments=[];
                  subjects=[];
                  final ProgressDialog pr = ProgressDialog(context: context);
                  pr.show(max: 100, msg: "Please wait");
                  await FirebaseFirestore.instance
                      .collection('schools')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      setState(() {
                        _TeacherCheckList model=new _TeacherCheckList(SchoolModel.fromMap(data, doc.reference.id),false);
                        schools.add(model);
                      });
                    });
                  });
                  await FirebaseFirestore.instance
                      .collection('departments')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      setState(() {
                        _TeacherCheckList model=new _TeacherCheckList(DepartmentModel.fromMap(data, doc.reference.id),false);
                        departments.add(model);
                      });
                    });
                  });
                  await FirebaseFirestore.instance
                      .collection('subjects')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                      setState(() {
                        _TeacherCheckList model=new _TeacherCheckList(SubjectModel.fromMap(data, doc.reference.id),false);
                        subjects.add(model);
                      });
                    });
                  });
                  pr.close();
                  _showEdit(context,model);
                },
              ),
            ],
          )),

        ]);
  }
}

class _TeacherCheckList{
  var model;bool check;

  _TeacherCheckList(this.model, this.check);
}

