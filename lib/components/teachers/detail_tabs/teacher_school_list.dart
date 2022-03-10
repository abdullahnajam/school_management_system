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
import 'package:school_management_system/model/school_model.dart';
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
class TeacherSchoolList extends StatefulWidget {
  List schoolIds;

  TeacherSchoolList(this.schoolIds);

  @override
  _TeacherSchoolListState createState() => _TeacherSchoolListState();
}


class _TeacherSchoolListState extends State<TeacherSchoolList> {



  Future<List<SchoolModel>> getDocuments() async {
    List<SchoolModel> subjects=[];
    await FirebaseFirestore.instance.collection('schools').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(widget.schoolIds.contains(doc.reference.id))
          subjects.add(SchoolModel.fromMap(data, doc.reference.id));
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
            "Schools",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder<List<SchoolModel>>(
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
                      child: Text("No Schools",style: TextStyle(color: Colors.white),),
                    );
                  }
                  else {
                    return DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn(
                            label: Text("School Name"),
                          ),
                          DataColumn(
                            label: Text("Abbreviation"),
                          ),
                          DataColumn(
                            label: Text("Academic Year"),
                          ),
                          DataColumn(
                            label: Text("Logo"),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            snapshot.data!.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text(snapshot.data![index].name)),
                                  DataCell(Text(snapshot.data![index].abbreviation)),
                                  DataCell(Text(snapshot.data![index].year)),
                                  DataCell(Image.network(snapshot.data![index].logo,height: 50,width: 50,)),
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




