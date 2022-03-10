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
import 'package:school_management_system/model/subject_model.dart';
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
class TeacherDepartmentList extends StatefulWidget {
  List departmentIds;

  TeacherDepartmentList(this.departmentIds);

  @override
  _TeacherDepartmentListState createState() => _TeacherDepartmentListState();
}


class _TeacherDepartmentListState extends State<TeacherDepartmentList> {



  Future<List<DepartmentModel>> getDocuments() async {
    List<DepartmentModel> subjects=[];
    await FirebaseFirestore.instance.collection('departments').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(widget.departmentIds.contains(doc.reference.id))
          subjects.add(DepartmentModel.fromMap(data, doc.reference.id));
      });
    });
    return subjects;

  }
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
            "Departments",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder<List<DepartmentModel>>(
              future: getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  if (snapshot.hasError) {
                    // Return error
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  else if(snapshot.data!.length==0){
                    return Center(
                      child: Text("No Departments",style: TextStyle(color: Colors.white),),
                    );
                  }
                  else {
                    return DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn(
                            label: Text("Department Name"),
                          ),
                          DataColumn(
                            label: Text("School Name"),
                          ),
                          DataColumn(
                            label: Text("Sub Department"),
                          ),
                          DataColumn(
                            label: Text("Main Department"),
                          ),

                        ],
                        rows: List<DataRow>.generate(
                            snapshot.data!.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text(snapshot.data![index].name)),
                                  DataCell(Text(snapshot.data![index].schoolName)),
                                  DataCell(snapshot.data![index].isSubDepartment?Text("Yes"):Text("No")),
                                  DataCell(Text(snapshot.data![index].mainDepartmentName)),
                            ])));
                  }
                }
              }
          ),



        ],
      ),
    );
  }


}




