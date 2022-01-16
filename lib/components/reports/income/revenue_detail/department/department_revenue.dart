import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:school_management_system/components/academic/classes/class_list.dart';
import 'package:school_management_system/components/financial/bus_fees/bus_fee_list.dart';
import 'package:school_management_system/components/financial/school_fees/school_fee_list.dart';
import 'package:school_management_system/components/financial/uniform_fee/uniform_fee_list.dart';
import 'package:school_management_system/components/reports/income/revenue_detail/school/school_revenue_list.dart';
import 'package:school_management_system/model/codeModel.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'department_revenue_list.dart';

class DepartmentRevenue extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;
  String type,schoolId;

  DepartmentRevenue(this._scaffoldKey,this.type,this.schoolId);

  @override
  _DepartmentRevenueState createState() => _DepartmentRevenueState();
}

class _DepartmentRevenueState extends State<DepartmentRevenue> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Department Report",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            icon: Icon(Icons.add),
                            label: Text("Export CSV"),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      DepartmentRevenueList(widget.type,widget.schoolId),

                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),



              ],
            )
          ],
        ),
      ),
    );
  }
}
