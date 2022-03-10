import 'dart:html';
import 'dart:ui' as UI;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/components/student/student_fees_list.dart';
import 'package:school_management_system/components/teachers/detail_tabs/teacher_dept_list.dart';
import 'package:school_management_system/components/teachers/detail_tabs/teacher_subject_list.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/model/teacherModel_model.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/student_detail_screen.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'detail_tabs/teacher_school_list.dart';
class TeacherDetailTab extends StatefulWidget {
  TeacherModel teacherModel;

  TeacherDetailTab(this.teacherModel);

  @override
  _TeacherDetailTabState createState() => _TeacherDetailTabState();
}


class _TeacherDetailTabState extends State<TeacherDetailTab> {




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
          DefaultTabController(
              length: 3,
              child:Column(
                children: [
                  Container(
                    padding : EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.grey,

                      /*indicator:  UnderlineTabIndicator(
                          borderSide: BorderSide(width: 0.0,color: Colors.white),
                          insets: EdgeInsets.symmetric(horizontal:16.0)
                      ),*/

                      tabs: [
                        Tab(text: 'Schools'),
                        Tab(text: 'Departments'),
                        Tab(text: 'Subjects'),
                      ],
                    ),

                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.55,

                    child: TabBarView(children: <Widget>[
                     TeacherSchoolList(widget.teacherModel.schools),
                      TeacherDepartmentList(widget.teacherModel.departments),
                      TeacherSubjectList(widget.teacherModel.subjects)

                    ]),
                  )

                ],

              )
          ),



        ],
      ),
    );
  }

}



