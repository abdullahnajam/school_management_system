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
import 'package:school_management_system/model/teacherModel_model.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class TeacherDetailSidebar extends StatefulWidget {
  TeacherModel teacherModel;

  TeacherDetailSidebar(this.teacherModel);

  @override
  _TeacherDetailSidebarState createState() => _TeacherDetailSidebarState();
}

class _TeacherDetailSidebarState extends State<TeacherDetailSidebar> {
 


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
                image: NetworkImage(widget.teacherModel.photo),
                fit: BoxFit.cover
              ),
              border: Border.all(color: Colors.grey,width: 1)
            ),
          ),
          Text("${widget.teacherModel.name}",
            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
          ),
          Text("Teacher",
            style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Teacher ID",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.uniqueId,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Email",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.email,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Blood Type",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.bloodType,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("National ID",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.nationalId,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Phone",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.phone,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Address",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.address,
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lesson Capacity",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.lessonCapacity.toString(),
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Staff",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.staff.toString(),
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Assign Duty",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
              ),
              Text(widget.teacherModel.assignDuty?"Yes":"No",
                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



