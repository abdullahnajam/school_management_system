import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  String filterDropDown="All";
  Future<int> getTotalRevenue()async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total+=int.parse(doc["fees"].toString());

      });
    });
    return total;
  }
  Future<int> getTotalAP()async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total+=int.parse(doc["fees"].toString());

      });
    });
    return total;
  }
  Future<int> getTotalAR()async{
    int total=0;
    await FirebaseFirestore.instance.collection('expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total+=int.parse(doc["amount"].toString());

      });
    });
    return total;
  }
  Future<int> getTotalActualIncome()async{

    int fees=0;
    int expenses=0;
    await FirebaseFirestore.instance.collection('expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        expenses+=int.parse(doc["amount"].toString());

      });
    });
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        fees+=int.parse(doc["fees"].toString());

      });
    });
    return fees-expenses;
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
         /* Row(
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
          SizedBox(height: defaultPadding,),*/
          Text(
            "Net Income",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Table(
              border: TableBorder.all(),
              defaultColumnWidth: FixedColumnWidth(120.0),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Net Income"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: FutureBuilder<int>(
                        future: getTotalRevenue(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(snapshot.data.toString()),
                              ),
                            ];
                          }
                          else if (snapshot.hasError) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("0"),
                              ),
                            ];
                          }
                          else {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("-"),
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
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("AR"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: FutureBuilder<int>(
                        future: getTotalAP(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(snapshot.data.toString()),
                              ),
                            ];
                          }
                          else if (snapshot.hasError) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("0"),
                              ),
                            ];
                          }
                          else {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("-"),
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
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("AP"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: FutureBuilder<int>(
                        future: getTotalAR(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(snapshot.data.toString()),
                              ),
                            ];
                          }
                          else if (snapshot.hasError) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("0"),
                              ),
                            ];
                          }
                          else {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("-"),
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
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Actual Income"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: FutureBuilder<int>(
                        future: getTotalActualIncome(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(snapshot.data.toString()),
                              ),
                            ];
                          }
                          else if (snapshot.hasError) {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("0"),
                              ),
                            ];
                          }
                          else {
                            children = <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text("-"),
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
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Table(
              border: TableBorder.all(),
              defaultColumnWidth: FixedColumnWidth(120.0),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Filter"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButton<String>(
                          value: filterDropDown,
                          icon: const Icon(Icons.keyboard_arrow_down),

                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              filterDropDown = newValue!;
                              getFilteredRevenue();
                            });
                          },
                          items: <String>[
                            'All',
                            'School Fees',
                            'Uniform Fees',
                            'Activity Fees',
                            'School Fees',
                            'Bus Fees'
                          ].map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Total Revenue"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child:  Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(totalRevenue.toString()),
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Earned Revenue"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child:  Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(earnedRevenue.toString()),
                      ),
                    ),

                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Unearned Revenue"),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child:  Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(unearnedRevenue.toString()),
                      ),
                    ),

                  ],
                ),





              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Actual Income"),
                    ),
                    FutureBuilder<int>(
                      future: getTotalActualIncome(),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                              ), width: 150,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),

                              alignment: Alignment.center,
                              child: Text(snapshot.data.toString()),
                            ),
                          ];
                        }
                        else if (snapshot.hasError) {
                          children = <Widget>[
                            Container(
                              decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              ), width: 150,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text("0"),
                            ),
                          ];
                        }
                        else {
                          children = <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                              ), width: 150,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text("-"),
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
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Cash"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                      ),
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("0"),
                    ),
                    Container(
                      color: primaryColor,
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Transfer",style: TextStyle(color: Colors.white),),
                    ),
                    Container(
                      color: primaryColor,
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Withdraw",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Visa"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                      ),
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("0"),
                    ),
                    Container(
                      color: primaryColor,
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Transfer",style: TextStyle(color: Colors.white),),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Bank"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                      ),
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("0"),
                    ),

                    Container(
                      color: primaryColor,
                      width: 150,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text("Withdraw",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ],
            ),
          ),
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
    getFilteredRevenue();
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


  int totalRevenue=0;
  int earnedRevenue=0;
  int unearnedRevenue=0;

  int totalExpense=0;
  int earnedExpense=0;
  int unearnedExpense=0;
  getFilteredRevenue()async{
    totalRevenue=0;
     earnedRevenue=0;
     unearnedRevenue=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          if(filterDropDown=="All"){
            earnedRevenue+=int.parse(doc["amountDue"].toString());
            totalRevenue+=int.parse(doc["fees"].toString());
            unearnedRevenue+=int.parse(doc["amountPaid"].toString());
          }
          else{
            if(doc['feeCategory']==filterDropDown){
              earnedRevenue+=int.parse(doc["amountDue"].toString());
              totalRevenue+=int.parse(doc["fees"].toString());
              unearnedRevenue+=int.parse(doc["amountPaid"].toString());
            }
          }

        });



      });
    });
  }


}




