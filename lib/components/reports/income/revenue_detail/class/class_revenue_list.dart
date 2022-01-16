import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:school_management_system/model/class_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/fee_model.dart';
import 'package:school_management_system/model/financial/activity_fee_model.dart';
import 'package:school_management_system/model/financial/bus_fee_model.dart';
import 'package:school_management_system/model/financial/uniform_fee_model.dart';
import 'package:school_management_system/model/grade_model.dart';
import 'package:school_management_system/model/school_model.dart';
import 'package:school_management_system/screens/financial/activity_fee_screen.dart';
import 'package:school_management_system/screens/financial/bus_fee_screen.dart';
import 'package:school_management_system/screens/financial/uniform_fee_screen.dart';
import 'package:school_management_system/screens/reports/income/class_report_screen.dart';
import 'package:school_management_system/screens/reports/income/grade_report_screen.dart';
import 'package:school_management_system/screens/reports/income/school_report_screen.dart';
import 'package:school_management_system/screens/reports/income/student_report_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class ClassRevenueList extends StatefulWidget {
  String type,gradeId;


  ClassRevenueList(this.type,this.gradeId);

  @override
  _ClassRevenueListState createState() => _ClassRevenueListState();
}


class _ClassRevenueListState extends State<ClassRevenueList> {




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
            widget.type,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('classes').where("gradeId",isEqualTo: widget.gradeId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.size==0){
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(80),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                      Text('No grade fee generated'),
                    ],
                  ),
                );
              }
              print("size ${snapshot.data!.size}");
              return new SizedBox(
                width: double.infinity,
                child: DataTable2(

                    showCheckboxColumn: false,
                    columnSpacing: defaultPadding,
                    minWidth: 600,
                    columns: [

                      DataColumn(
                        label: Text("Class"),
                      ),
                      DataColumn(
                        label: Text("Total"),
                      ),
                      DataColumn(
                        label: Text("Paid"),
                      ),
                      DataColumn(
                        label: Text("Due"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),


                    ],
                    rows: _buildList(context, snapshot.data!.docs)

                ),
              );
            },
          ),


        ],
      ),
    );
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }
  Future<int> getTotalRevenue(String valueType,String id)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').where("classId",isEqualTo: id).where("feeCategory",isEqualTo:widget.type).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(valueType=="earned"){
          total+=int.parse(doc["amountDue"].toString());
        }
        else if(valueType=="total"){
          total+=int.parse(doc["fees"].toString());
        }
        else{
          total+=int.parse(doc["amountPaid"].toString());
        }

      });
    });
    return total;
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    final model = ClassModel.fromSnapshot(data);
    return DataRow(
        cells: [
          DataCell(Text(model.name)),
          DataCell(FutureBuilder<int>(
            future: getTotalRevenue("total",model.id),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Container(
                    child: Text(snapshot.data.toString()),
                  ),
                ];
              }
              else if (snapshot.hasError) {
                print(snapshot.error.toString());
                children = <Widget>[
                  Container(

                    child: Text("0"),
                  ),
                ];
              }
              else {
                children = <Widget>[
                  Container(

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
          )),
          DataCell(FutureBuilder<int>(
            future: getTotalRevenue("earned",model.id),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Container(

                    child: Text(snapshot.data.toString()),
                  ),
                ];
              }
              else if (snapshot.hasError) {
                children = <Widget>[
                  Container(

                    child: Text("0"),
                  ),
                ];
              }
              else {
                children = <Widget>[
                  Container(

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
          )),
          DataCell(FutureBuilder<int>(
            future: getTotalRevenue("unearned",model.id),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Container(

                    child: Text(snapshot.data.toString()),
                  ),
                ];
              }
              else if (snapshot.hasError) {
                children = <Widget>[
                  Container(

                    child: Text("0"),
                  ),
                ];
              }
              else {
                children = <Widget>[
                  Container(

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
          )),
          DataCell(
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentReportScreen(widget.type, model.id)));

              },
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("View Details",style: TextStyle(color: Colors.blue),),
              ),
            ),
          ),

        ]);
  }
}



