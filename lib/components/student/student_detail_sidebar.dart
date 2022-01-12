import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:school_management_system/model/category_model.dart';
import 'package:school_management_system/model/parent_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class StudentDetailSidebar extends StatefulWidget {
  StudentModel studentModel;

  StudentDetailSidebar(this.studentModel);

  @override
  _StudentDetailSidebarState createState() => _StudentDetailSidebarState();
}

class _StudentDetailSidebarState extends State<StudentDetailSidebar> {
 


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.studentModel.photo),
                fit: BoxFit.cover
              ),
              border: Border.all(color: Colors.grey,width: 1)
            ),
          ),
          Text("${widget.studentModel.firstName} ${widget.studentModel.lastName}",
            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
          ),
          Text("Student",
            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Student ID",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.studentModel.uniqueId,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("School",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.studentModel.school,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Department",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.studentModel.department,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Grade",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.studentModel.grade,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Class",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.studentModel.className,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



