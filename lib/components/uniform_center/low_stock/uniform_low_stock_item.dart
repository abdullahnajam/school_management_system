import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/components/expense/expense_list.dart';
import 'package:school_management_system/components/uniform_center/low_stock/uniform_low_stock_list.dart';
import 'package:school_management_system/components/uniform_center/uniform_stock/uniform_stock_list.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;



class UniformLowStockItem extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  UniformLowStockItem(this._scaffoldKey);

  @override
  _UniformLowStockItemState createState() => _UniformLowStockItemState();
}

class _UniformLowStockItemState extends State<UniformLowStockItem> {






  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Low Stock Items",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [


                      SizedBox(height: defaultPadding),
                      UniformLowStockItemList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
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
