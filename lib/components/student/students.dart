import 'dart:html';
import 'dart:ui' as UI;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:school_management_system/components/academic/classes/class_list.dart';
import 'package:school_management_system/components/student/parent_category_sidebar.dart';
import 'package:school_management_system/components/student/student_list.dart';
import 'package:school_management_system/model/codeModel.dart';
import 'package:school_management_system/model/parent_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class Students extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;
  String classId;

  Students(this._scaffoldKey,this.classId);

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {

  var _firstNameController=TextEditingController();
  var _lastNameController=TextEditingController();
  var _emailController=TextEditingController();
  var _phoneController=TextEditingController();
  var _addressController=TextEditingController();

  var _pfirstNameController=TextEditingController();
  var _plastNameController=TextEditingController();
  var _pemailController=TextEditingController();
  var _pphoneController=TextEditingController();
  var _paddressController=TextEditingController();
  var _jobController=TextEditingController();
  var _relationController=TextEditingController();


  var schoolController=TextEditingController();
  var departmentController=TextEditingController();
  var gradeController=TextEditingController();
  var _classController=TextEditingController();
  var _parentController=TextEditingController();
  List<String> sids=[];
  bool isParentRegistered=false;

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

  register(String photo,int sibling,String pid,String sid,String did,String gid, String cid,String parentImage) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");


    if(!isParentRegistered){
      pid="P${DateTime.now().millisecondsSinceEpoch.toString()}";
      _parentController.text="${_pfirstNameController.text} ${_plastNameController.text}";
      FirebaseFirestore.instance.collection('parents').doc(pid).set({
        'firstName': _pfirstNameController.text,
        'lastName': _plastNameController.text,
        'phone': _pphoneController.text,
        'job': _jobController.text,
        'password':"password",
        'token': "none",
        'topic': 'parent',
        'status':'Active',
        'email': _pemailController.text.trim(),
        'photo':parentImage,
        'address': _paddressController.text,
        'isArchived': false,
        'datePosted': DateTime.now().millisecondsSinceEpoch,
      }).onError((error, stackTrace){
        pr.close();
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error',style: TextStyle(color: Colors.black),),
              content: SingleChildScrollView(
                child: ListBody(
                  children:  <Widget>[
                    Text("error: ${error.toString()}",style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(

                  child: const Text('OK',style: TextStyle(color: Colors.black)),
                  onPressed: () async{
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        print("error: ${error.toString()}");
      });

    }
    sibling=0;
    await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(pid==doc["parentId"]){
          sibling++;
          sids.add(doc.reference.id);
        }
      });
    });

    FirebaseFirestore.instance.collection('students').add({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phone': _phoneController.text,
      'school': schoolController.text,
      'uniqueId': "s${schoolController.text[0]}${departmentController.text[0]}${codes!.student}",
      'department': departmentController.text,
      'grade': gradeController.text,
      'className': _classController.text,
      'parent': _parentController.text,
      'password':"password",
      'token': "none",
      'relation': _relationController.text,
      'topic': 'student',
      'status':'Active',
      'email': _emailController.text.trim(),
      'schoolId':sid,
      'departmentId':did,
      'gradeId':gid,
      'classId':cid,
      'parentId':pid.toString(),
      'siblings':sibling,
      'siblingsIds':sids,
      'photo':photo,
      'address': _addressController.text,
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      int number=codes!.student;
      number++;
      FirebaseFirestore.instance.collection('key').doc('codes').update({
        'student':number
      });
      pr.close();
      Navigator.pop(context);
    }).onError((error, stackTrace){
      pr.close();
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error',style: TextStyle(color: Colors.black),),
            content: SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[
                  Text("error: ${error.toString()}",style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(

                child: const Text('OK',style: TextStyle(color: Colors.black)),
                onPressed: () async{
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      print("error: ${error.toString()}");
    });
    pr.close();
  }

  Future<void> _showAddDialog() async {
    String imageUrl="";
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    bool imageUploading=false;
    String parentUrl="";
    fb.UploadTask? _uploadParentTask;
    Uri parentUri;
    bool parentImageUploading=false;
    int _step=0;
    String parentId="";
    String schoolId="",departmentId="",gradeId="",classId="";
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

            uploadParentImageToFirebase(File imageFile) async {
              final filePath = 'images/${DateTime.now()}.png';

              print("put");
              setState((){
                parentImageUploading=true;
                _uploadParentTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
              });

              fb.UploadTaskSnapshot taskSnapshot = await _uploadParentTask!.future;
              parentUri = await taskSnapshot.ref.getDownloadURL();
              setState((){
                parentUrl=parentUri.toString();
                parentImageUploading=false;
                //imageUrl= "https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/bookingPics%2F1622649147001?alt=media&token=45a4483c-2f29-48ab-bcf1-813fd8fa304b";
                print(parentUrl);
              });

            }

            uploadParentImage() async {
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
                          uploadParentImageToFirebase(file);
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
                              child: Text("Add Student",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                  child: _step==2?  Text('Add Student'):Text('Continue'),
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
                              register(imageUrl,0,parentId,schoolId,departmentId,gradeId,classId,parentUrl);
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
                                                          stream: FirebaseFirestore.instance.collection('departments')
                                                              .where("schoolName",isEqualTo:schoolController.text).snapshots(),
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
                                                          stream: FirebaseFirestore.instance.collection('grades')
                                                              .where("department",isEqualTo:departmentController.text).snapshots(),
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
                                                                        gradeController.text="${data['name']}";
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
                                        controller: gradeController,
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
                                                          stream: FirebaseFirestore.instance.collection('classes')
                                                              .where("grade",isEqualTo:gradeController.text).snapshots(),
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

                                  CheckboxListTile(
                                    title: const Text('Parent Already Registered?',style: TextStyle(color: Colors.black),),
                                    value: isParentRegistered,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isParentRegistered = value!;
                                      });
                                    },
                                    secondary: const Icon(Icons.people,color: Colors.black,),
                                  ),
                                  SizedBox(height: 10,),
                                  isParentRegistered?
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
                                                        height: MediaQuery.of(context).size.height,
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
                                                                  _parentController.text = "${suggestion.firstName} ${suggestion.lastName}";
                                                                  parentId = suggestion.id;
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(

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
                                                          ],
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
                                  ):
                                  Column(
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
                                                    controller: _pfirstNameController,
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
                                                    controller: _plastNameController,
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
                                            "Email",
                                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                          ),
                                          TextFormField(
                                            controller: _pemailController,
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
                                            controller: _pphoneController,
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
                                            controller: _paddressController,
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
                                            controller: _jobController,
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
                                            child: parentImageUploading?Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Uploading",style: TextStyle(color: primaryColor),),
                                                  SizedBox(width: 10,),
                                                  CircularProgressIndicator()
                                                ],),
                                            ):parentUrl==""?
                                            Image.asset("assets/images/placeholder.png",height: 100,width: 150,fit: BoxFit.cover,)
                                                :Image.network(parentUrl,height: 100,width: 150,fit: BoxFit.cover,),
                                          ),

                                          InkWell(
                                            onTap: (){
                                              uploadParentImage();
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
                        ),
                      ),
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Student",widget._scaffoldKey),
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
                            onPressed: () {
                              _showAddDialog();
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Student"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      StudentList(widget.classId),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      //if (Responsive.isMobile(context)) ParentSidebar(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
               /* if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: ParentSidebar(),
                  ),
*/

              ],
            )
          ],
        ),
      ),
    );
  }
}
