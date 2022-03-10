import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/utils/constants.dart';

Future<void> showStudentListDialog(BuildContext context) async {
  String schoolId="",departmentId="",gradeId="",classId="";
  var schoolController=TextEditingController();
  var departmentController=TextEditingController();
  var gradeController=TextEditingController();
  var _classController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
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
                            child: Text("Select Class",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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

                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        print("tap");

                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentScreen(classId)));
                        }
                      },
                      child: Container(
                        height: 50,
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Text("Search",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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