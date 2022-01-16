import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/components/reports/income/income_detail.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;


class Income extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  Income(this._scaffoldKey);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Income",widget._scaffoldKey),
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

                        ],
                      ),

                      SizedBox(height: defaultPadding),
                      IncomeDetail(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      //if (Responsive.isMobile(context)) FeeCategorySidebar(),

                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
               /* if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: FeeCategorySidebar(),
                  ),*/




              ],
            )
          ],
        ),
      ),
    );
  }
}
