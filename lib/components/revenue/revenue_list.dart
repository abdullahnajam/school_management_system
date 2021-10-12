import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/employee_model.dart';
import 'package:school_management_system/model/fee_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/academic/school_screen.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/screens/revenue_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class RevenueList extends StatefulWidget {

  @override
  _RevenueListState createState() => _RevenueListState();
}


class _RevenueListState extends State<RevenueList> {

  bool isSearched=false;
  String searchValue='Name';
  String searchFeeCategory="";
  var _searchStudentController=TextEditingController();
  var _cashontroller=TextEditingController();
  var _bankController=TextEditingController();
  var _visaController=TextEditingController();
  var _messageController=TextEditingController();
  String _searchStudentId="";
  setSearchId(String id){
    setState(() {
      _searchStudentId=id;
    });
  }
  setSearchFee(String category){
    setState(() {
      searchFeeCategory=category;
    });
  }
  Future<void> _showCategoryDialog() async {

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
                height: MediaQuery.of(context).size.height*0.9,
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
                            child: Text("Select Fees Type",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SchoolScreen())),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  searchFeeCategory="School Fees";
                                  setSearchFee("School Fees");
                                  Navigator.pop(context);

                                  _showSearchDialog();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                          style: BorderStyle.solid
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/fee.png",height: 100,width: 100,color: Colors.grey[600],),
                                      SizedBox(height: 20,),
                                      Text("School Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  searchFeeCategory="Bus Fees";
                                  setSearchFee("Bus Fees");
                                  Navigator.pop(context);

                                  _showSearchDialog();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                          style: BorderStyle.solid
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/bus.png",height: 100,width: 100,color: Colors.grey[600],),
                                      SizedBox(height: 20,),
                                      Text("Bus Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  searchFeeCategory="Uniform Fees";
                                  setSearchFee("Uniform Fees");
                                  Navigator.pop(context);
                                  _showSearchDialog();

                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                          style: BorderStyle.solid
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/uniform.png",height: 100,width: 100,color: Colors.grey[600],),
                                      SizedBox(height: 20,),
                                      Text("Uniform Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  searchFeeCategory="Activity Fees";
                                  setSearchFee("Activity Fees");
                                  Navigator.pop(context);
                                  _showSearchDialog();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                          style: BorderStyle.solid
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/activity.png",height: 100,width: 100,color: Colors.grey[600],),
                                      SizedBox(height: 20,),
                                      Text("Activity Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Others",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  searchFeeCategory="Supply Fees";
                                  setSearchFee("Supply Fees");
                                  Navigator.pop(context);
                                  _showSearchDialog();

                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.3,
                                          style: BorderStyle.solid
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset("assets/images/supply.png",height: 100,width: 100,color: Colors.grey[600],),
                                      SizedBox(height: 20,),
                                      Text("Supply Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                    ],
                                  ),
                                ),
                              ),
                              Container()
                            ],
                          ),


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
  Future<void> _showMobileCategoryDialog() async {

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
                height: MediaQuery.of(context).size.height*0.9,
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
                            child: Text("Select Fees Type",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(Icons.close,color: Colors.grey,),
                              onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SchoolScreen())),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: (){
                              searchFeeCategory="School Fees";
                              setSearchFee("School Fees");
                              Navigator.pop(context);

                              _showSearchDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.3,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/fee.png",height: 100,width: 100,color: Colors.grey[600],),
                                  SizedBox(height: 20,),
                                  Text("School Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              searchFeeCategory="Bus Fees";
                              setSearchFee("Bus Fees");
                              Navigator.pop(context);

                              _showSearchDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.3,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/bus.png",height: 100,width: 100,color: Colors.grey[600],),
                                  SizedBox(height: 20,),
                                  Text("Bus Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              searchFeeCategory="Uniform Fees";
                              setSearchFee("Uniform Fees");
                              Navigator.pop(context);
                              _showSearchDialog();

                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.3,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/uniform.png",height: 100,width: 100,color: Colors.grey[600],),
                                  SizedBox(height: 20,),
                                  Text("Uniform Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              searchFeeCategory="Activity Fees";
                              setSearchFee("Activity Fees");
                              Navigator.pop(context);
                              _showSearchDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.3,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/activity.png",height: 100,width: 100,color: Colors.grey[600],),
                                  SizedBox(height: 20,),
                                  Text("Activity Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              searchFeeCategory="Supply Fees";
                              setSearchFee("Supply Fees");
                              Navigator.pop(context);
                              _showSearchDialog();

                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.3,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/supply.png",height: 100,width: 100,color: Colors.grey[600],),
                                  SizedBox(height: 20,),
                                  Text("Supply Fees",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey[400]),),
                                ],
                              ),
                            ),
                          ),


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
  Future<void> _showSearchDialog() async {

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
                                if(Responsive.isMobile(context)){
                                  _showMobileCategoryDialog();
                                }
                                else{
                                  _showCategoryDialog();
                                }

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
                                TextFormField(
                                  controller: _searchStudentController,
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
                                                            List<StudentModel> suggestion = [];
                                                            await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
                                                              querySnapshot.docs.forEach((doc) {
                                                                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                                                if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase()))
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
                                                            setState(() {
                                                              _searchStudentController.text = "${suggestion.firstName} ${suggestion.lastName}";

                                                              setSearchId(suggestion.id);
                                                            });

                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
                                                                    Text("No Students Added",style: TextStyle(color: Colors.black))

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
                                                                        _searchStudentController.text="${data['firstName']} ${data['lastName']}";
                                                                        //searchStudentId=document.reference.id;
                                                                        setSearchId(document.reference.id);
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
                                                                    subtitle:  Text("${data['email']}",style: TextStyle(color: Colors.black),),
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
                                    hintText: "",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                                TextFormField(
                                  controller: _searchStudentController,
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
                                                            List<StudentModel> suggestion = [];
                                                            await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
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
                                                            _searchStudentController.text = "${suggestion.firstName} ${suggestion.lastName}";
                                                            //searchStudentId = suggestion.id;
                                                            setSearchId(suggestion.id);

                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
                                                                    Text("No Students Added",style: TextStyle(color: Colors.black))

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
                                                                        _searchStudentController.text="${data['firstName']} ${data['lastName']}";
                                                                        //searchStudentId=document.reference.id;
                                                                        setSearchId(document.reference.id);
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
                                                                    subtitle:  Text("${data['email']}",style: TextStyle(color: Colors.black),),
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
                                    hintText: "",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                                  TextFormField(
                                    controller: _searchStudentController,
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
                                                                hintText: "Search by phone",
                                                                hintStyle: TextStyle(color: Colors.grey),
                                                                floatingLabelBehavior:
                                                                FloatingLabelBehavior.always,
                                                              ),
                                                            ),
                                                            suggestionsCallback: (pattern) async {
                                                              List<StudentModel> suggestion = [];
                                                              await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
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
                                                                  suggestion.email,
                                                                  style: TextStyle(color: Colors.black),
                                                                ),
                                                              );
                                                            },
                                                            onSuggestionSelected: (StudentModel suggestion) {
                                                              _searchStudentController.text = "${suggestion.firstName} ${suggestion.lastName}";
                                                              //searchStudentId = suggestion.id;
                                                              setSearchId(suggestion.id);

                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: StreamBuilder<QuerySnapshot>(
                                                            stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
                                                                      Text("No Students Added",style: TextStyle(color: Colors.black))

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
                                                                          _searchStudentController.text="${data['firstName']} ${data['lastName']}";
                                                                          //searchStudentId=document.reference.id;
                                                                          setSearchId(document.reference.id);
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
                                                                      subtitle:  Text("${data['email']}",style: TextStyle(color: Colors.black),),
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
                                      hintText: "",
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ],
                              ),
                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              isSearched=true;
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: Text("Find Fees",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )



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
    return role==""?Center(child:CircularProgressIndicator()):Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fees",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('fees')
                .where("studentId",isEqualTo: _searchStudentId)
                .where("feeCategory",isEqualTo: searchFeeCategory).snapshots(),
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
                print("new $searchFeeCategory $_searchStudentId");
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
                      Text('No fees are added'),
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
                      label: Text("Student"),
                    ),
                    DataColumn(
                      label: Text("Type"),
                    ),
                    DataColumn(
                      label: Text("Fee"),
                    ),
                    DataColumn(
                      label: Text("Due Date"),
                    ),
                    DataColumn(
                      label: Text("Year"),
                    ),
                    DataColumn(
                      label: Text("Status"),
                    ),
                    DataColumn(
                      label: Text("Payment Info"),
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
  String role="";
  @override
  void initState() {
    //print("data ${widget.studentId} ${widget.category}");
    FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          role=data['role'];
          if(Responsive.isMobile(context)){
            _showMobileCategoryDialog();
          }
          else{
            _showCategoryDialog();
          }
        });

        print('role exists on the database');
      }
    });
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }
  DateTime? dueDate,fromDate;
  var _studentController=TextEditingController();
  var _schoolController=TextEditingController();
  var _departmentController=TextEditingController();
  var _parentController=TextEditingController();
  var _dueDateController=TextEditingController();
  var _fromDateController=TextEditingController();
  var _discountController=TextEditingController();
  var _feeCategoryController=TextEditingController();
  var _feesController=TextEditingController();
  var _academicYearController=TextEditingController();
  var _gradeController=TextEditingController();



  Future<void> _showEdit(BuildContext context,FeeModel model) async {
    String _schoolId=model.schoolId,_departmentId=model.departmentId,_feeCategoryId=model.feeCategoryId;
    String _studentId=model.studentId,_parentId=model.parentId,_discountId=model.discountId;
    String _gradeId=model.gradeId;
    bool _isDiscountInPercentage=model.isDiscountInPercentage;
    int dueDateInMilli=model.dueDateInMilli;
    int fromDateInMilli=model.fromDateInMilli;
    _studentController.text=model.student;
    _schoolController.text=model.school;
    _parentController.text=model.parent;
    _departmentController.text=model.department;
    _dueDateController.text=model.dueDate;
    _fromDateController.text=model.fromDate;
    _discountController.text=model.discount;
    _feeCategoryController.text=model.feeCategory;
    _feesController.text=model.fees.toString();
    _academicYearController.text=model.academicYear;
    _gradeController.text=model.grade;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _formKey = GlobalKey<FormState>();






            _dueDate(BuildContext context) async {
              dueDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (dueDate != null && dueDate != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  _dueDateController.text = f.format(dueDate!).toString();
                  dueDateInMilli=dueDate!.millisecondsSinceEpoch;
                });
            }
            _fromDate(BuildContext context) async {
              fromDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (fromDate != null && fromDate != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  _fromDateController.text = f.format(fromDate!).toString();
                  fromDateInMilli=fromDate!.millisecondsSinceEpoch;
                });
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
                                  "Student",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _studentController,
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
                                                            List<StudentModel> suggestion = [];
                                                            await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
                                                              querySnapshot.docs.forEach((doc) {
                                                                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                                                                if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase()))
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
                                                            _studentController.text = "${suggestion.firstName} ${suggestion.lastName}";
                                                            _studentId = suggestion.id;
                                                            _parentId=suggestion.parentId;
                                                            _schoolId=suggestion.schoolId;
                                                            _departmentId=suggestion.departmentId;
                                                            _gradeId=suggestion.gradeId;
                                                            _departmentController.text=suggestion.department;
                                                            _gradeController.text=suggestion.grade;
                                                            _schoolController.text=suggestion.school;
                                                            _parentController.text=suggestion.parent;
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection('students').snapshots(),
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
                                                                    Text("No Students Added",style: TextStyle(color: Colors.black))

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
                                                                        _studentController.text="${data['firstName']} ${data['lastName']}";
                                                                        _studentId=document.reference.id;
                                                                        _parentId=data['parentId'];
                                                                        _parentController.text=data['parent'];
                                                                        _schoolId=data['schoolId'];
                                                                        _departmentId=data['departmentId'];
                                                                        _gradeId=data['gradeId'];
                                                                        _gradeController.text=data['grade'];
                                                                        _schoolController.text=data['school'];
                                                                        _departmentController.text=data['department'];
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
                                                                    subtitle:  Text("${data['email']}",style: TextStyle(color: Colors.black),),
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
                                    hintText: "",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Books",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .apply(color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fee Category",
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
                                                    stream: FirebaseFirestore.instance.collection('fee_categories').snapshots(),
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
                                                              Text("No Fee Category Added",style: TextStyle(color: Colors.black))

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
                                                                  _feeCategoryController.text="${data['name']}";
                                                                  _feeCategoryId=document.reference.id;
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
                                  controller: _feeCategoryController,
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
                                  "Academic Year",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _academicYearController,
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
                                  "Fees",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _feesController,
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
                                  "Discount",
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
                                                    stream: FirebaseFirestore.instance.collection('discounts').snapshots(),
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
                                                              Text("No Discounts Added",style: TextStyle(color: Colors.black))

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
                                                                  _discountController.text="${data['name']}";
                                                                  _discountId=document.reference.id;
                                                                  data['type']=='Percentage'?_isDiscountInPercentage==true:_isDiscountInPercentage=false;
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
                                  controller: _discountController,
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
                                  "Due Date",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  onTap: (){
                                    _dueDate(context);
                                  },
                                  controller: _dueDateController,
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
                                  "From Date",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  onTap: (){
                                    _fromDate(context);
                                  },
                                  controller: _fromDateController,
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
                                final ProgressDialog pr = ProgressDialog(context: context);
                                pr.show(max: 100, msg: "Adding");
                                FirebaseFirestore.instance.collection('fees').doc(model.id).update({
                                  'student': _studentController.text,
                                  'school': _schoolController.text,
                                  'department': _departmentController.text,
                                  'studentId': _studentId,
                                  'parentId': _parentId,
                                  'parent': _parentController.text,
                                  'schoolId': _schoolId,
                                  'dueDate': _dueDateController.text,
                                  'fromDate': _fromDateController.text,
                                  'discount': _discountController.text,
                                  'discountId': _discountId,
                                  'feeCategoryId': _feeCategoryId,
                                  'feeCategory': _feeCategoryController.text,
                                  'fees': int.parse(_feesController.text),
                                  'academicYear': _academicYearController.text,
                                  'dueDateInMilli': dueDateInMilli,
                                  'fromDateInMilli': fromDateInMilli,
                                  'grade': _gradeController.text,
                                  'gradeId': _gradeId,
                                  'departmentId': _departmentId,
                                  'isDiscountInPercentage': _isDiscountInPercentage,
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
                                child: Text("Update Fees",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
  Future<void> _showChangeStatusDialog(FeeModel model,BuildContext context) async {
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
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Change Status",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
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
                    SizedBox(height: 10,),
                    ListTile(
                      onTap: (){
                        var width;
                        if(Responsive.isMobile(context)){
                          width=MediaQuery.of(context).size.width*0.8;
                        }
                        else if(Responsive.isTablet(context)){
                          width=MediaQuery.of(context).size.width*0.6;
                        }
                        else if(Responsive.isDesktop(context)){
                          width=MediaQuery.of(context).size.width*0.3;
                        }
                        AwesomeDialog(
                          width: width,
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('fees').doc(model.id).update({
                              'status':"Not Paid"
                            }).then((value) {

                              Navigator.pop(context);

                            }).onError((error, stackTrace) {
                              var width;
                              if(Responsive.isMobile(context)){
                                width=MediaQuery.of(context).size.width*0.8;
                              }
                              else if(Responsive.isTablet(context)){
                                width=MediaQuery.of(context).size.width*0.6;
                              }
                              else if(Responsive.isDesktop(context)){
                                width=MediaQuery.of(context).size.width*0.3;
                              }
                              AwesomeDialog(
                                width: width,
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: secondaryColor,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Not Paid",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      onTap: (){
                        var width;
                        if(Responsive.isMobile(context)){
                          width=MediaQuery.of(context).size.width*0.8;
                        }
                        else if(Responsive.isTablet(context)){
                          width=MediaQuery.of(context).size.width*0.6;
                        }
                        else if(Responsive.isDesktop(context)){
                          width=MediaQuery.of(context).size.width*0.3;
                        }
                        AwesomeDialog(
                          width: width,
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('fees').doc(model.id).update({
                              'status':"Paid"
                            }).then((value) {


                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              var width;
                              if(Responsive.isMobile(context)){
                                width=MediaQuery.of(context).size.width*0.8;
                              }
                              else if(Responsive.isTablet(context)){
                                width=MediaQuery.of(context).size.width*0.6;
                              }
                              else if(Responsive.isDesktop(context)){
                                width=MediaQuery.of(context).size.width*0.3;
                              }
                              AwesomeDialog(
                                width: width,
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: secondaryColor,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Paid",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      onTap: (){
                        var width;
                        if(Responsive.isMobile(context)){
                          width=MediaQuery.of(context).size.width*0.8;
                        }
                        else if(Responsive.isTablet(context)){
                          width=MediaQuery.of(context).size.width*0.6;
                        }
                        else if(Responsive.isDesktop(context)){
                          width=MediaQuery.of(context).size.width*0.3;
                        }
                        AwesomeDialog(
                          width: width,
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          dialogBackgroundColor: secondaryColor,
                          title: 'Change Status',
                          desc: 'Are you sure you want to change status?',
                          btnCancelOnPress: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));
                          },
                          btnOkOnPress: () {
                            FirebaseFirestore.instance.collection('fees').doc(model.id).update({
                              'status':"Over Due"
                            }).then((value) {

                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              var width;
                              if(Responsive.isMobile(context)){
                                width=MediaQuery.of(context).size.width*0.8;
                              }
                              else if(Responsive.isTablet(context)){
                                width=MediaQuery.of(context).size.width*0.6;
                              }
                              else if(Responsive.isDesktop(context)){
                                width=MediaQuery.of(context).size.width*0.3;
                              }
                              AwesomeDialog(
                                width: width,
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                dialogBackgroundColor: secondaryColor,
                                title: 'Error : Unable to change status',
                                desc: '${error.toString()}',

                                btnOkOnPress: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));

                                },
                              )..show();
                            });
                          },
                        )..show();

                      },
                      title: Text("Over Due",style: TextStyle(color: Colors.black),),
                    ),
                    Divider(color: Colors.grey,),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _showPaymentInfoDialog(FeeModel model) async {

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
                height: MediaQuery.of(context).size.height*0.7,
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
                            child: Text("Fee Payment Info",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                        ),

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
                                "Amount Paid",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              Text(
                                model.amountPaid.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .apply(color: Colors.black),
                              ),

                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Amount Due",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              Text(
                                model.amountDue.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .apply(color: Colors.black),
                              ),

                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cash Payment",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _cashontroller,
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
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                                "Bank Payment",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _bankController,
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
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                                "Visa Payment",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: _visaController,
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
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                                "Confirmation Message",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 3,
                                controller: _messageController,
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
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15,),
                          InkWell(
                            onTap: (){
                              int cash=0,visa=0,bank=0;
                              int paid=model.amountPaid,due=model.amountDue;
                              if(_cashontroller.text!="")
                                cash=int.parse(_cashontroller.text);

                              if(_visaController.text!="")
                                visa=int.parse(_cashontroller.text);
                              if(_bankController.text!="")
                                bank=int.parse(_cashontroller.text);
                              int totalPaid=cash+visa+bank;
                              paid=paid+totalPaid;
                              due=due-totalPaid;
                              FirebaseFirestore.instance.collection('fees').doc(model.id).update({
                                'amountPaid': paid,
                                'amountDue': due,
                                'cashPayment': cash,
                                'visaPayment': visa,
                                'masterCardPayment': bank,
                                'message':_messageController.text
                              }).then((value) => Navigator.pop(context));


                            },
                            child: Container(
                              height: 50,
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: Text("submit",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                            ),
                          )



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
  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    final model = FeeModel.fromSnapshot(data);
    return DataRow(
        cells: [
          DataCell(Text(model.student)),
          DataCell(Text(model.feeCategory)),
          DataCell(Text(model.fees.toString())),
          DataCell(Text(model.dueDate.toString())),
          DataCell(Text(model.academicYear)),
          DataCell(Text(model.status.toString()),onTap: (){
            if(role=="Accountant"){
              _showChangeStatusDialog(model, context);
            }
          }),
          DataCell(Text("View"),onTap: (){
            if(model.message!="none")
              _messageController.text=model.message;
            _showPaymentInfoDialog(model);
          }),
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
                    title: 'Delete Fees',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmployeeScreen()));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('fees').doc(model.id).delete().then((value) =>
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
}




