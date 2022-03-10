import 'dart:html';
import 'dart:ui' as UI;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/components/academic/classes/class_list.dart';
import 'package:school_management_system/components/student/parent_category_sidebar.dart';
import 'package:school_management_system/components/student/student_detail_sidebar.dart';
import 'package:school_management_system/components/student/student_detail_tab.dart';
import 'package:school_management_system/components/student/student_list.dart';
import 'package:school_management_system/components/teachers/teacher_detail_sidebar.dart';
import 'package:school_management_system/components/teachers/teacher_detail_tab.dart';
import 'package:school_management_system/model/codeModel.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/model/teacherModel_model.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class TeacherDetails extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  TeacherModel teacherModel;

  TeacherDetails(this._scaffoldKey,this.teacherModel);

  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {





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

                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: TeacherDetailSidebar(widget.teacherModel),
                  ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            },
                            icon: Icon(Icons.print),
                            label: Text("Print"),
                          ),
                        ],
                      ),
                      if (Responsive.isMobile(context)) TeacherDetailSidebar(widget.teacherModel),
                      SizedBox(height: defaultPadding),
                      TeacherDetailTab(widget.teacherModel),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),

                    ],
                  ),
                ),



              ],
            )
          ],
        ),
      ),
    );
  }
}
