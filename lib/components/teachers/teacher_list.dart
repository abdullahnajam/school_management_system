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

  List<_TeacherCheckList> schools=[];
  List<_TeacherCheckList> departments=[];
  List<_TeacherCheckList> subjects=[];

  Future<void> _showEdit(BuildContext context,TeacherModel model) async {
    List schoolId=model.schools;
    List departmentId=model.departments;
    List subjectId=model.subjects;
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
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();

            _nameController.text=model.name;
            _phoneController.text=model.phone;
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
                          controlsBuilder: (BuildContext context, {UI.VoidCallback? onStepContinue, UI.VoidCallback? onStepCancel}) {
                            return Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: onStepContinue,
                                  child: _step==3?  Text('Update Teacher'):Text('Continue'),
                                ),
                                TextButton(
                                  onPressed: onStepCancel,
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
                                  itemCount: departments.length,
                                  itemBuilder: (context,int i){
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CheckboxListTile(
                                          title: Text(departments[i].model.name),
                                          value: departments[i].check,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              departments[i].check = value!;
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
                                  itemCount: subjects.length,
                                  itemBuilder: (context,int i){
                                    return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CheckboxListTile(
                                          title: Text(subjects[i].model.name),
                                          value: subjects[i].check,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              subjects[i].check = value!;
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
        cells: [
          DataCell(Text(model.uniqueId)),
          DataCell(Text(model.name)),
          DataCell(Text(model.email)),
          DataCell(Text(model.phone)),
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

