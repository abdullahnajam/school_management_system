import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/screens/academic/school_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  bool isPasswordHidden=true;

  var emailController=TextEditingController();
  var changeEmailController=TextEditingController();
  var passwordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordView() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }
  Future<void> _showErrorDialog(String message){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',style: TextStyle(color: Colors.black),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text("$message",style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(

              child: const Text('OK',style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text("A mail has been sent to you. Please check your mail for reset password link"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showForgotPasswordDialog() async {
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
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
                              child: Text("Forget Password",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                                  "Email",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: changeEmailController,
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
                              onTap: ()async{
                                if (_formKey.currentState!.validate()) {
                                  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                                  await firebaseAuth.sendPasswordResetEmail(email: changeEmailController.text.trim()).whenComplete((){
                                    _showPasswordDialog();
                                  }).catchError((onError){
                                    print(onError.toString());

                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                color: secondaryColor,
                                alignment: Alignment.center,
                                child: Text("Change",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Responsive.isMobile(context)?
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.black),),
              ),
              SizedBox(height: 20,),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: secondaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: secondaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: secondaryColor,
                    ),
                  ),
                  filled: true,
                  //prefixIcon: Icon(Icons.email_outlined,color: Colors.black,size: 22,),
                  fillColor: Colors.grey[300],
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: passwordController,
                obscureText: isPasswordHidden,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: secondaryColor
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: secondaryColor
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: secondaryColor
                    ),
                  ),
                  fillColor: Colors.grey[300],
                  filled: true,
                  /*suffix: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      isPasswordHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),*/
                  hintText: "Enter your password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: ()async{
                  final ProgressDialog pr = ProgressDialog(context: context);
                  if (_formKey.currentState!.validate()) {
                    try {
                      print("email:${emailController.text.trim()}");
                      pr.show(max: 100, msg: "Please wait");
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text
                      ).then((value) {
                        pr.close();
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => SchoolScreen()));

                      }).onError((error, stackTrace){
                        pr.close();
                        print(emailController.text.trim());
                        print(error.toString());
                        _showErrorDialog(error.toString());
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        pr.close();
                        print('No user found for that email.');
                        _showErrorDialog("No user found for that email.");
                      } else if (e.code == 'wrong-password') {
                        pr.close();
                        print('Wrong password provided for that user.');
                        _showErrorDialog("Wrong password provided for that user.");
                      }
                      else{
                        _showErrorDialog(e.message.toString());
                      }
                    }
                  }
                },
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  height: 50,
                  child: Text("SIGN IN",style: TextStyle(fontSize:20,color: Colors.white),),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  InkWell(
                    onTap: (){
                      _showForgotPasswordDialog();
                    },
                    child: Container(
                      child: Text("Forgot Password?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.black),),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      )
          :Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            color: Colors.white,
            width: Responsive.isDesktop(context)?width*0.28:width*0.4,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.black),),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      filled: true,
                      //prefixIcon: Icon(Icons.email_outlined,color: Colors.black,size: 22,),
                      fillColor: Colors.grey[300],
                      hintText: "Enter your email",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: secondaryColor
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: secondaryColor
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: secondaryColor
                        ),
                      ),
                      fillColor: Colors.grey[300],
                      filled: true,
                      /*suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),*/
                      hintText: "Enter your password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: ()async{
                      final ProgressDialog pr = ProgressDialog(context: context);
                      if (_formKey.currentState!.validate()) {
                        try {
                          print("email:${emailController.text.trim()}");
                          pr.show(max: 100, msg: "Please wait");
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text
                          ).then((value) {
                            pr.close();
                            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => SchoolScreen()));

                          }).onError((error, stackTrace){
                            pr.close();
                            print(emailController.text.trim());
                            print(error.toString());
                            _showErrorDialog(error.toString());
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            pr.close();
                            print('No user found for that email.');
                            _showErrorDialog("'Wrong password provided for that user.");
                          } else if (e.code == 'wrong-password') {
                            pr.close();
                            print('Wrong password provided for that user.');
                            _showErrorDialog("Wrong password provided for that user.");
                          }
                          else{
                            _showErrorDialog(e.message.toString());
                          }
                        }
                      }
                    },
                    child: Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      height: 50,
                      child: Text("SIGN IN",style: TextStyle(fontSize:20,color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _showForgotPasswordDialog();
                        },
                        child: Container(
                          child: Text("Forgot Password?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.black),),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      )
    );
  }


}
