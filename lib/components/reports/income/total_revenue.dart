import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/screens/reports/income/school_report_screen.dart';
import 'package:school_management_system/screens/teacher_screen.dart';

class TotalRevenue extends StatefulWidget {
  const TotalRevenue({Key? key}) : super(key: key);

  @override
  _TotalRevenueState createState() => _TotalRevenueState();
}

class _TotalRevenueState extends State<TotalRevenue> {
  Future<int> getTotalSchoolRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('school_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }

  Future<int> getTotalBusRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('bus_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }
  Future<int> getTotalUniformRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('uniform_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }
  Future<int> getTotalActivityRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('activity_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }
  Future<int> getTotalBookRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('book_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }
  Future<int> getTotalOtherRevenue()async{
    int totalRevenue=0;
    await FirebaseFirestore.instance.collection('other_fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalRevenue+=int.parse(doc["fees"]);
      });
    });
    return totalRevenue;
  }


  Future<int> getTotalSchoolEarnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="School Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }

  Future<int> getTotalBusEarnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="Bus Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }

  Future<int> getTotalUniformUnearnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="Uniform Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }
  Future<int> getTotalActivityUnearnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="Activity Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }

  Future<int> getTotalBookUnearnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="Book Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }

  Future<int> getTotalOtherEarnedRevenue(String valueType)async{
    int total=0;
    await FirebaseFirestore.instance.collection('fees').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['feeCategory']=="Other Fees"){
          if(valueType=="earned"){
            total+=int.parse(doc["amountDue"].toString());
          }
          else{
            total+=int.parse(doc["amountPaid"].toString());
          }
        }

      });
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Text(""),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("School"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Busses"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Uniform"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Activity"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Book"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Other"),
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
                  child: Text("Total"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalSchoolRevenue(),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBusRevenue(),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalUniformRevenue(),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalActivityRevenue(),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBookRevenue(),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalOtherRevenue(),
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
                  child: Text("Earned"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalSchoolEarnedRevenue("earned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBookUnearnedRevenue("earned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalUniformUnearnedRevenue("earned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalActivityUnearnedRevenue("earned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBookUnearnedRevenue("earned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalOtherEarnedRevenue("earned"),
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
                  child: Text("Un Earned"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalSchoolEarnedRevenue("unearned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBookUnearnedRevenue("unearned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalUniformUnearnedRevenue("unearned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalActivityUnearnedRevenue("unearned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalBookUnearnedRevenue("unearned"),
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
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: FutureBuilder<int>(
                  future: getTotalOtherEarnedRevenue("unearned"),
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
                  child: Text("Action"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("School Fees")));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("Bus Fees")));

                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("Uniform Fees")));

                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("Activity Fees")));

                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("Book Fees")));

                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SchoolReportScreen("Other Fees")));

                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text("View Details",style: TextStyle(color: Colors.blue),),
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
