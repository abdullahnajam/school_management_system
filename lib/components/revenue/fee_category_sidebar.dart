import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:school_management_system/model/category_model.dart';
import 'package:school_management_system/screens/discount_screen.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
class FeeCategorySidebar extends StatefulWidget {
  const FeeCategorySidebar({Key? key}) : super(key: key);

  @override
  _FeeCategorySidebarState createState() => _FeeCategorySidebarState();
}

class _FeeCategorySidebarState extends State<FeeCategorySidebar> {
  var _nameController=TextEditingController();
  var _nameEditController=TextEditingController();

  var _mainCatController=TextEditingController();
  var _mainCatEditController=TextEditingController();

  bool isSubCategory=false;
  bool isEditSubCategory=false;

  add(String id) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('fee_categories').add({
      'name': _nameController.text,
      'mainCategoryName': isSubCategory?_mainCatController.text:"none",
      'mainCategoryId': id,
      'isSubCategory': isSubCategory,
      'isArchived': false,
      'datePosted':DateTime.now().millisecondsSinceEpoch

    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }

  Future<void> _showAddDialog() async {
    String _mainCategoryId="none";
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
                width: MediaQuery.of(context).size.width*0.3,
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
                              child: Text("Add Category",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                      CheckboxListTile(

                        title: const Text('Sub Category',style: TextStyle(color: Colors.black),),
                        value: isSubCategory,
                        onChanged: (bool? value) {
                          setState(() {
                            isSubCategory = value!;
                          });
                        },
                        secondary: const Icon(Icons.subdirectory_arrow_left,color: Colors.black,),
                      ),
                      SizedBox(height: 10,),
                      isSubCategory?
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Main Category",
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
                                              stream: FirebaseFirestore.instance.collection('discount_categories')
                                                  .where("isSubCategory",isEqualTo: false).snapshots(),
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
                                                            _mainCatController.text="${data['name']}";
                                                            _mainCategoryId=document.reference.id;
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
                            controller: _mainCatController,
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
                      ):Container(),


                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          print("tap");
                          add(_mainCategoryId);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Add Category",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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

  Future<void> _showEditDialog(CategoryModel model) async {
    _nameEditController.text=model.name;
    bool isEditSubCategory=model.isSubCategory;
    _mainCatEditController.text=model.mainCategoryName;
    String mainCatEditId=model.mainCategoryId;


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
                width: MediaQuery.of(context).size.width*0.3,
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
                              child: Text("Edit Category",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                            "Name",
                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                          ),
                          TextFormField(
                            controller: _nameEditController,
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

                        title: const Text('Sub Category',style: TextStyle(color: Colors.black),),
                        value: isEditSubCategory,
                        onChanged: (bool? value) {
                          setState(() {
                            isEditSubCategory = value!;
                          });
                        },
                        secondary: const Icon(Icons.subdirectory_arrow_left,color: Colors.black,),
                      ),
                      SizedBox(height: 10,),
                      isEditSubCategory?
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Main Category",
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
                                              stream: FirebaseFirestore.instance.collection('discount_categories')
                                                  .where("isSubCategory",isEqualTo: false).snapshots(),
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
                                                            _mainCatEditController.text="${data['name']}";
                                                            mainCatEditId=document.reference.id;
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
                            controller: _mainCatController,
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
                      ):Container(),


                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          final ProgressDialog pr = ProgressDialog(context: context);
                          pr.show(max: 100, msg: "Adding");
                          FirebaseFirestore.instance.collection('employee_categories').doc(model.id).update({
                            /*String id,name,mainCategoryName,mainCategoryId;
  bool isSubCategory,isArchived;*/
                            'name': _nameEditController.text,
                            'mainCategoryName': isEditSubCategory?_mainCatEditController.text:"none",
                            'mainCategoryId': isEditSubCategory?mainCatEditId:"none",
                            'isSubCategory': isEditSubCategory,

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
                          child: Text("Update Category",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  String role="";
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          role=data['role'];
        });
        print('Document exists on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return role==""?Center(child: CircularProgressIndicator(),):Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fee Categories",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          role=="Accountant"?Container():InkWell(
            onTap: (){
              _showAddDialog();
            },
            child: Text(
              "Add Category",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          SizedBox(height: defaultPadding),
          Container(
              margin: EdgeInsets.only(top: defaultPadding),
              padding: EdgeInsets.all(defaultPadding),
              child: Container(
                height: MediaQuery.of(context).size.height*0.2,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('fee_categories').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                            Text("Something Went Wrong")

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
                            Text("No Category Added")

                          ],
                        ),
                      );

                    }

                    return new ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return new Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  title: Text(data['name']),
                                  subtitle: InkWell(
                                      onTap: (){
                                        _showEditDialog(CategoryModel.fromMap(data, document.reference.id));
                                      },
                                      child: Text("Edit",style: TextStyle(color:Colors.black),)
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_forever,color: Colors.black,),
                                    onPressed: (){
                                      AwesomeDialog(
                                        dialogBackgroundColor: Colors.black,
                                        width: MediaQuery.of(context).size.width*0.3,
                                        context: context,
                                        dialogType: DialogType.QUESTION,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Delete Category',
                                        desc: 'Are you sure you want to delete this record?',
                                        btnCancelOnPress: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DiscountScreen()));
                                        },
                                        btnOkOnPress: () {
                                          FirebaseFirestore.instance.collection('fee_categories').doc(document.reference.id).delete().then((value) =>
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DiscountScreen())));
                                        },
                                      )..show();
                                    },
                                  ),

                                ),
                              ),
                            )
                        );
                      }).toList(),
                    );
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
}



