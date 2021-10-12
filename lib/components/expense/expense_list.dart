import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/model/expense_model.dart';
import 'package:school_management_system/screens/expense_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
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
            "Spa Expenses",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('expenses')
                .orderBy("datePosted", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              if (snapshot.data!.size == 0) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(80),
                  alignment: Alignment.center,
                  child: Text("No expenses are registered"),
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
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Amount"),
                      ),
                      DataColumn(
                        label: Text("Type"),
                      ),
                      DataColumn(
                        label: Text("Payment Method"),
                      ),
                      DataColumn(
                        label: Text("Status"),
                      ),
                      DataColumn(
                        label: Text("Due Date"),
                      ),

                      DataColumn(
                        label: Text("Notes"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),
                    ],
                    rows: _buildList(context, snapshot.data!.docs)),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<DataRow> _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

var dateController = TextEditingController();
var typeController = TextEditingController();
var noteController = TextEditingController();
var amountController = TextEditingController();
var paymentMethodController = TextEditingController();
var dueDateController = TextEditingController();
String typeId = "";
String status="";

int dateInMilli=0,dueDateInMilli=0;
update(String id, BuildContext context) async {
  final ProgressDialog pr = ProgressDialog(context: context);
  pr.show(max: 100, msg: "Loading");
  FirebaseFirestore.instance.collection('expenses').doc(id).update({
    'date': dateController.text,
    'note': noteController.text,
    'type': typeController.text,
    'amount': amountController.text,
    'typeId': typeId,
    'status': status,
    'dateInMilli': dateInMilli,
    'dueDateInMilli': dueDateInMilli,
    'paymentMethod': paymentMethodController.text,
    'dueDate': dueDateController.text,
  }).then((value) {
    pr.close();
    print("added");
    Navigator.pop(context);
  }).onError((error, stackTrace) {
    pr.close();
    var width;
    if (Responsive.isMobile(context)) {
      width = MediaQuery.of(context).size.width * 0.8;
    } else if (Responsive.isTablet(context)) {
      width = MediaQuery.of(context).size.width * 0.6;
    } else if (Responsive.isDesktop(context)) {
      width = MediaQuery.of(context).size.width * 0.3;
    }
    AwesomeDialog(
      width: width,
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      dialogBackgroundColor: Colors.white,
      title: 'Error',
      desc: '${error.toString()}',
      btnOkOnPress: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ExpenseScreen()));
      },
    )..show();
  });
}
DateTime? start,due;
Future<void> _showChangeStatusDialog(ExpenseModel model,BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Change Status",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: IconButton(
                            icon: Icon(Icons.close,color: Colors.grey,),
                            onPressed: ()=>Navigator.pop(context),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    onTap: (){
                      var width;
                      if(Responsive.isMobile(context)){
                        width=MediaQuery.of(context).size.width*0.8;
                      }
                      else if(Responsive.isTablet(context)){
                        width=MediaQuery.of(context).size.width*0.6;
                      }
                      else if(Responsive.isDesktop(context)){
                        width=MediaQuery.of(context).size.width*0.3;
                      }
                      AwesomeDialog(
                        width: width,
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        dialogBackgroundColor: secondaryColor,
                        title: 'Change Status',
                        desc: 'Are you sure you want to change status?',
                        btnCancelOnPress: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));
                        },
                        btnOkOnPress: () {
                          FirebaseFirestore.instance.collection('expenses').doc(model.id).update({
                            'status':"Paid"
                          }).then((value) {

                            Navigator.pop(context);

                          }).onError((error, stackTrace) {
                            var width;
                            if(Responsive.isMobile(context)){
                              width=MediaQuery.of(context).size.width*0.8;
                            }
                            else if(Responsive.isTablet(context)){
                              width=MediaQuery.of(context).size.width*0.6;
                            }
                            else if(Responsive.isDesktop(context)){
                              width=MediaQuery.of(context).size.width*0.3;
                            }
                            AwesomeDialog(
                              width: width,
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogBackgroundColor: secondaryColor,
                              title: 'Error : Unable to change status',
                              desc: '${error.toString()}',

                              btnOkOnPress: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));

                              },
                            )..show();
                          });
                        },
                      )..show();

                    },
                    title: Text("Paid",style: TextStyle(color: Colors.black),),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
              onTap: (){
                var width;
                if(Responsive.isMobile(context)){
                  width=MediaQuery.of(context).size.width*0.8;
                }
                else if(Responsive.isTablet(context)){
                  width=MediaQuery.of(context).size.width*0.6;
                }
                else if(Responsive.isDesktop(context)){
                  width=MediaQuery.of(context).size.width*0.3;
                }
                AwesomeDialog(
                  width: width,
                  context: context,
                  dialogType: DialogType.QUESTION,
                  animType: AnimType.BOTTOMSLIDE,
                  dialogBackgroundColor: secondaryColor,
                  title: 'Change Status',
                  desc: 'Are you sure you want to change status?',
                  btnCancelOnPress: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));
                  },
                  btnOkOnPress: () {
                    FirebaseFirestore.instance.collection('expenses').doc(model.id).update({
                      'status':"Pending"
                    }).then((value) {

                      Navigator.pop(context);

                    }).onError((error, stackTrace) {
                      var width;
                      if(Responsive.isMobile(context)){
                        width=MediaQuery.of(context).size.width*0.8;
                      }
                      else if(Responsive.isTablet(context)){
                        width=MediaQuery.of(context).size.width*0.6;
                      }
                      else if(Responsive.isDesktop(context)){
                        width=MediaQuery.of(context).size.width*0.3;
                      }
                      AwesomeDialog(
                        width: width,
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        dialogBackgroundColor: secondaryColor,
                        title: 'Error : Unable to change status',
                        desc: '${error.toString()}',

                        btnOkOnPress: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));

                        },
                      )..show();
                    });
                  },
                )..show();

              },
              title: Text("Pending",style: TextStyle(color: Colors.black),),
            ),
                  Divider(color: Colors.grey,),

                ],
              ),
            ),
          );
        },
      );
    },
  );
}
Future<void> _showEdit(ExpenseModel model, BuildContext context) async {
  dueDateController.text = model.dueDate;
  dateController.text = model.date;
  typeController.text = model.type;
  noteController.text = model.note;
  amountController.text = model.amount;
  paymentMethodController.text = model.paymentMethod;
  typeId = model.typeId;
  status=model.status;
  dateInMilli=model.dateInMilli;dueDateInMilli=model.dueDateInMilli;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();



          _selectDate(BuildContext context) async {
            start = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Refer step 1
              firstDate: DateTime.now(),
              lastDate: DateTime(2025),
            );
            if (start != null && start != DateTime.now())
              setState(() {
                final f = new DateFormat('dd-MM-yyyy');
                dateInMilli=start!.millisecondsSinceEpoch;
                dateController.text = f.format(start!).toString();
              });
          }
          _dueDate(BuildContext context) async {
            due = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Refer step 1
              firstDate: DateTime.now(),
              lastDate: DateTime(2025),
            );
            if (due != null && due != DateTime.now())
              setState(() {
                final f = new DateFormat('dd-MM-yyyy');
                dueDateInMilli=due!.millisecondsSinceEpoch;
                dueDateController.text = f.format(due!).toString();
              });
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "Edit Expense",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .apply(color: Colors.black),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Amount",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: amountController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () {
                                  _selectDate(context);
                                },
                                controller: dateController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Due Date",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () {
                                  _dueDate(context);
                                },
                                controller: dueDateController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              insetAnimationDuration:
                                                  const Duration(seconds: 1),
                                              insetAnimationCurve:
                                                  Curves.fastOutSlowIn,
                                              elevation: 2,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'expense_types')
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/wrong.png",
                                                              width: 150,
                                                              height: 150,
                                                            ),
                                                            Text(
                                                                "Something Went Wrong",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    if (snapshot.data!.size ==
                                                        0) {
                                                      return Center(
                                                          child: Text(
                                                              "No Type Added",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)));
                                                    }

                                                    return new ListView(
                                                      shrinkWrap: true,
                                                      children: snapshot
                                                          .data!.docs
                                                          .map((DocumentSnapshot
                                                              document) {
                                                        Map<String, dynamic>
                                                            data =
                                                            document.data()
                                                                as Map<String,
                                                                    dynamic>;

                                                        return new Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15.0),
                                                          child: ListTile(
                                                            onTap: () {
                                                              setState(() {
                                                                typeController
                                                                        .text =
                                                                    "${data['type']}";
                                                                typeId = document
                                                                    .reference
                                                                    .id;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            title: Text(
                                                              "${data['type']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                                controller: typeController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Method",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: paymentMethodController,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status",
                                style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: status,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      status = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Paid',
                                    'Pending'
                                  ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notes",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(color: Colors.black),
                              ),
                              TextFormField(
                                controller: noteController,
                                minLines: 3,
                                maxLines: 3,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  hintText: "",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              print("tap");
                              update(model.id, context);
                            },
                            child: Container(
                              height: 50,
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: Text(
                                "Update",
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .apply(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = ExpenseModel.fromSnapshot(data);
  return DataRow(cells: [
    DataCell(Text(model.date)),
    DataCell(Text(model.amount)),
    DataCell(Text(model.type)),
    DataCell(Text(model.paymentMethod)),
    DataCell(Text(model.status),onTap: (){
      _showChangeStatusDialog(model, context);
    }),
    DataCell(Text(model.dueDate)),
    DataCell(Text(
      model.note,
      maxLines: 1,
    )),
    DataCell(Row(
      children: [
        IconButton(
          icon: Icon(Icons.delete_forever),
          color: primaryColor,
          onPressed: () {
            var width;
            if (Responsive.isMobile(context)) {
              width = MediaQuery.of(context).size.width * 0.8;
            } else if (Responsive.isTablet(context)) {
              width = MediaQuery.of(context).size.width * 0.6;
            } else if (Responsive.isDesktop(context)) {
              width = MediaQuery.of(context).size.width * 0.3;
            }
            AwesomeDialog(
              width: width,
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              dialogBackgroundColor: Colors.white,
              title: 'Delete Expense',
              desc: 'Are you sure you want to delete this record?',
              btnCancelOnPress: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ExpenseScreen()));
              },
              btnOkOnPress: () {
                FirebaseFirestore.instance
                    .collection('expenses')
                    .doc(model.id)
                    .delete()
                    .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ExpenseScreen())));
              },
            )..show();
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          color: primaryColor,
          onPressed: () {
            _showEdit(model, context);
          },
        ),
      ],
    )),
  ]);
}
