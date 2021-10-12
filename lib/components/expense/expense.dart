import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_system/screens/expense_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;

import 'expense_list.dart';
import 'expense_sidebar.dart';

class Expenses extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;

  Expenses(this._scaffoldKey);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  var dateController = TextEditingController();
  var typeController = TextEditingController();
  var noteController = TextEditingController();
  var amountController = TextEditingController();
  var paymentMethodController = TextEditingController();
  var dueDateController = TextEditingController();
  String status='Paid';
  String typeId = "";

  int dateInMilli=0,dueDateInMilli=0;
  register() async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    FirebaseFirestore.instance.collection('expenses').add({
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
      'isArchived':false,
      'datePosted': DateTime.now().millisecondsSinceEpoch
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

  Future<void> _showAddExpenseDialog() async {
    DateTime? start;
    DateTime? due;
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  dueDateInMilli=start!.millisecondsSinceEpoch;
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
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
                                "Add Expenses",
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
                                                    builder: (BuildContext
                                                            context,
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
                                                            .map(
                                                                (DocumentSnapshot
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
                                if (_formKey.currentState!.validate()) {
                                  register();
                                }
                              },
                              child: Container(
                                height: 50,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text(
                                  "Add Expense",
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
        print('Document exists on the database');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: role==""?Center(child: CircularProgressIndicator(),):Column(
          children: [
            Header("Expenses", widget._scaffoldKey),
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
                          role=="Accountant"?Container():ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            onPressed: () {
                              _showAddExpenseDialog();
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add Expense"),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      ExpenseList(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) ExpenseSideBar(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: ExpenseSideBar(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
