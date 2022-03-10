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
class TeacherSubjectList extends StatefulWidget {
  List subjectIds;

  TeacherSubjectList(this.subjectIds);

  @override
  _TeacherSubjectListState createState() => _TeacherSubjectListState();
}


class _TeacherSubjectListState extends State<TeacherSubjectList> {



  Future<List<SubjectModel>> getDocuments() async {
    List<SubjectModel> subjects=[];
    await FirebaseFirestore.instance.collection('subjects').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(widget.subjectIds.contains(doc.reference.id))
          subjects.add(SubjectModel.fromMap(data, doc.reference.id));
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
            "Subjects",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder<List<SubjectModel>>(
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
                      child: Text("No Subjects",style: TextStyle(color: Colors.white),),
                    );
                  }
                  else {
                    return DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn(
                            label: Text("Subject"),
                          ),
                          DataColumn(
                            label: Text("School"),
                          ),
                          DataColumn(
                            label: Text("Department"),
                          ),
                          DataColumn(
                            label: Text("Grade"),
                          ),

                        ],
                        rows: List<DataRow>.generate(
                            snapshot.data!.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text(snapshot.data![index].name)),
                                  DataCell(Text(snapshot.data![index].school)),
                                  DataCell(Text(snapshot.data![index].department)),
                                  DataCell(Text(snapshot.data![index].grade)),
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




