import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_system/components/admins/role_sidebar.dart';
import 'package:school_management_system/components/admins/user_list.dart';
import 'package:school_management_system/provider/UserDataProvider.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;


class Roles extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Roles(this._scaffoldKey);

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {


  var nameController=TextEditingController();

  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var roleController=TextEditingController();
  register(String id,bool addAdmin) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);
    try {
      pr.show(max: 100, msg: "Please wait");
      await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      ).then((value){
        
        FirebaseFirestore.instance.collection('admins').doc(value.user!.uid).set({
          'username': nameController.text,
          'status':'Active',
          'role':roleController.text,
          'roleId':id,
          'addAdmin':addAdmin,
          'email': emailController.text.trim(),
        }).then((value) {

          pr.close();
          Navigator.pop(context);
        }).onError((error, stackTrace){
          final snackBar = SnackBar(content: Text("Database Error"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        pr.close();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        pr.close();
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      pr.close();
    }
    pr.close();
    await app.delete();
  }
  Future<void> _showAddDialog() async {
   String roleId="";
   bool addAdmin=false;
    
    final _formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

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
                              child: Text("Add Admin",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                                  "Email",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: emailController,
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
                                  "Password",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller:passwordController,
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
                                  "Role",
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
                                                  padding: EdgeInsets.all(10),
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  child: StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection('roles').snapshots(),
                                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Column(
                                                            children: [
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
                                                            child: Text("No Roles Found",style: TextStyle(color: Colors.black))
                                                        );

                                                      }

                                                      return new ListView(
                                                        shrinkWrap: true,
                                                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                          return new Padding(
                                                            padding: const EdgeInsets.only(top: 15.0),
                                                            child: ListTile(
                                                              onTap: (){
                                                                setState(() {
                                                                  roleController.text="${data['role']}";
                                                                  roleId=document.reference.id;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              title: Text("${data['role']}",style: TextStyle(color: Colors.black),),
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
                                  controller: roleController,
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
                              title: const Text('Add Other Admins',style: TextStyle(color: Colors.black),),
                              value: addAdmin,
                              onChanged: (bool? value) {
                                setState(() {
                                  addAdmin = value!;
                                });
                              },
                              secondary: const Icon(Icons.add,color: Colors.black,),
                            ),


                            SizedBox(height: 15,),
                            GestureDetector(
                              onTap: (){
                                print("ov");
                                if (_formKey.currentState!.validate()) {
                                  register(roleId,addAdmin);
                                }
                              },
                              child: Container(
                                height: 50,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text("Add Admin",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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









  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Users",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(provider.adminData!.addAdmin)
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
                            label: Text("Add Admin"),
                          ),

                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      RoleList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context) && provider.adminData!.addAdmin) RoleSidebar(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context) && provider.adminData!.addAdmin)
                  Expanded(
                    flex: 2,
                    child: RoleSidebar(),
                  ),



              ],
            )
          ],
        ),
      ),
    );
  }
}
