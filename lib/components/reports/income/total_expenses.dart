import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/screens/teacher_screen.dart';

class TotalExpenses extends StatefulWidget {
  const TotalExpenses({Key? key}) : super(key: key);

  @override
  _TotalExpensesState createState() => _TotalExpensesState();
}

class _TotalExpensesState extends State<TotalExpenses> {
  Future<int> getTotalSchoolRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('school_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
  }
  Future<int> getTotalBusRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('bus_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
  }
  Future<int> getTotalUniformRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('uniform_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
  }
  Future<int> getTotalActivityRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('activity_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
  }
  Future<int> getTotalBookRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('book_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
  }
  Future<int> getTotalOtherRevenue()async{
    int totalExpenses=0;
    await FirebaseFirestore.instance.collection('other_expenses').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        totalExpenses+=int.parse(doc["fees"]);
      });
    });
    return totalExpenses;
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
                  child: Text("Action"),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));
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
