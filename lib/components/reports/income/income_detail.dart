import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/components/reports/income/total_expenses.dart';
import 'package:school_management_system/components/reports/income/total_revenue.dart';
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
class IncomeDetail extends StatefulWidget {

  @override
  _IncomeDetailState createState() => _IncomeDetailState();
}


class _IncomeDetailState extends State<IncomeDetail> {
  Future<int> getTotalRevenue()async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total+=int.parse(doc["fees"].toString());

      });
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Income",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              FutureBuilder<int>(
                future: getTotalRevenue(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(snapshot.data.toString(),style: Theme.of(context).textTheme.headline4!.apply(color: primaryColor),),
                      ),
                    ];
                  }
                  else if (snapshot.hasError) {
                    children = <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("0",style: Theme.of(context).textTheme.headline4!.apply(color: primaryColor),),
                      ),
                    ];
                  }
                  else {
                    children = <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("-",style: Theme.of(context).textTheme.headline6!.apply(color: primaryColor),),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              )
            ],
          ),
          SizedBox(height: defaultPadding,),
          Text(
            "Revenue",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TotalRevenue(),
          Text(
            "Expenses",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TotalExpenses(),



        ],
      ),
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

        print('role exists on the database');
      }
    });
  }

}




