import 'dart:html';
import 'dart:ui' as UI;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/components/teachers/teacher_list.dart';
import 'package:school_management_system/model/codeModel.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/school_model.dart';
import 'package:school_management_system/model/subject_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class Teachers extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Teachers(this._scaffoldKey);

  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  List<_TeacherCheckList> schools=[];
  List<_TeacherCheckList> departments=[];
  List<_TeacherCheckList> subjects=[];

  var _nameController=TextEditingController();
  var _emailController=TextEditingController();
  var _phoneController=TextEditingController();
  var _addressController=TextEditingController();

  CodeModel? codes;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('key').doc('codes').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        codes=CodeModel.fromMap(data);
      }
    });
  }

  var _nationalIdController=TextEditingController();
  var _bloodTypeController=TextEditingController();
  register(String photo) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");
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
    FirebaseFirestore.instance.collection('teachers').add({

      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'password':"password",
      'token': "none",
      'topic': 'teacher',
      'uniqueId': "t${subjectIds.length}${departmentIds.length}${subjectIds.length}${codes!.teacher}",
      'status':'Active',
      'schools': schoolIds,
      'departments': departmentIds,
      'subjects': subjectIds,
      'email': _emailController.text.trim(),
      'photo':photo,
      'nationalId': _nationalIdController.text,
      'bloodType': _bloodTypeController.text,
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      int number=codes!.teacher;
      number++;
      FirebaseFirestore.instance.collection('key').doc('codes').update({
        'teacher':number
      });
      pr.close();
      Navigator.pop(context);
    }).onError((error, stackTrace){
      pr.close();
      Navigator.pop(context);
      print("error: ${error.toString()}");
    });
    pr.close();
  }
  Future<void> _showAddDialog() async {
    List<_TeacherCheckList> tempDepartments=departments;
    List<_TeacherCheckList> tempSub=subjects;
    String imageUrl="";
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    int _step = 0;
    bool imageUploading=false;
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
                height: MediaQuery.of(context).size.width*0.9,
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
                            child: Text("Add Teacher",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                child: _step==3?  Text('Add Teacher'):Text('Continue'),
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
                            register(imageUrl);
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
                                      "Email",
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                    ),
                                    TextFormField(
                                      controller: _emailController,
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Teacher",widget._scaffoldKey),
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
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical:
                                defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: ()async {
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
                              _showAddDialog();
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Teacher"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      TeacherList(),
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
class _TeacherCheckList{
  var model;bool check;

  _TeacherCheckList(this.model, this.check);
}
