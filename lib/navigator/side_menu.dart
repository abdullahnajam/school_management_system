
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/screens/academic/class_screen.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/grade_screen.dart';
import 'package:school_management_system/screens/academic/school_screen.dart';
import 'package:school_management_system/screens/academic/school_year_screen.dart';
import 'package:school_management_system/screens/academic/subject_screen.dart';
import 'package:school_management_system/screens/activity_screen.dart';
import 'package:school_management_system/screens/admin_screen.dart';
import 'package:school_management_system/screens/books/book_delivery_screen.dart';
import 'package:school_management_system/screens/books/book_screen.dart';
import 'package:school_management_system/screens/bus/bus_coordinator_screen.dart';
import 'package:school_management_system/screens/bus/bus_driver_screen.dart';
import 'package:school_management_system/screens/bus/bus_line_screen.dart';
import 'package:school_management_system/screens/bus/bus_route_screen.dart';
import 'package:school_management_system/screens/bus/bus_screen.dart';
import 'package:school_management_system/screens/discount_screen.dart';
import 'package:school_management_system/screens/employee_screen.dart';
import 'package:school_management_system/screens/expense_screen.dart';
import 'package:school_management_system/screens/financial/activity_fee_screen.dart';
import 'package:school_management_system/screens/financial/bus_fee_screen.dart';
import 'package:school_management_system/screens/financial/school_fee_screen.dart';
import 'package:school_management_system/screens/financial/uniform_fee_screen.dart';
import 'package:school_management_system/screens/places/place_screen.dart';
import 'package:school_management_system/screens/revenue_screen.dart';
import 'package:school_management_system/screens/signin.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/screens/supply/supply_delivery_screen.dart';
import 'package:school_management_system/screens/supply/supply_items_screen.dart';
import 'package:school_management_system/screens/supply/supply_stock_screen.dart';
import 'package:school_management_system/screens/supply/supply_supplier_screen.dart';
import 'package:school_management_system/screens/supply/supply_variation_screen.dart';
import 'package:school_management_system/screens/teacher_screen.dart';
import 'package:school_management_system/screens/transfer_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_Supplier_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_category_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_delivery_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_items_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_stock_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_variation_screen.dart';
import 'package:school_management_system/utils/constants.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
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
    return role==""?Center(child: CircularProgressIndicator(),):Drawer(

        child: Container(
          color: bgColor,
          child:ListView(
            children: [
              DrawerHeader(
                child: Image.asset("assets/images/logo.png"),
              ),

              DrawerListTile(
                title: "Administration",
                svgSrc: "assets/icons/school.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminScreen()));

                },
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Academic",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "School",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SchoolScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Department",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DepartmentScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Grades",
                    svgSrc: "assets/icons/grade.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GradeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Classes",
                    svgSrc: "assets/icons/class.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ClassScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Subjects",
                    svgSrc: "assets/icons/subject.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SubjectScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "School Year",
                    svgSrc: "assets/icons/subject.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SchoolYearScreen()));

                    },
                  ),
                ],
              ),
              DrawerListTile(
                title: "Teachers",
                svgSrc: "assets/icons/teacher.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));

                },
              ),

              DrawerListTile(
                title: "Employees",
                svgSrc: "assets/icons/employee.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmployeeScreen()));

                },
              ),
              DrawerListTile(
                title: "Students",
                svgSrc: "assets/icons/students.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentScreen()));

                },
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Book Center",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Books",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Delivery",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookDeliveryScreen()));

                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Uniform Center",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Uniform Category",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformCategoryScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Variation",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformVariationScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Items",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformItemsScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Stock",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformStockScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Supplier",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformSupplierScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Delivery",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformDeliveryScreen()));

                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Supply Center",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Supply Variation",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SupplyVariationScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Supply Items",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SupplyItemsScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Supply Stock",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SupplyStockScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Supply Supplier",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SupplySupplierScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Supply Delivery",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SupplyDeliveryScreen()));

                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "School Busses",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Bus",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Bus Lines",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusLineScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Bus Drivers",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusDriverScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: " Bus Coordinator",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusCoordinatorScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: " Bus Route",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusRouteScreen()));

                    },
                  ),
                ],
              ),
              DrawerListTile(
                title: "Activity",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ActivityScreen()));

                },
              ),
              DrawerListTile(
                title: "Transfer",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TransferScreen()));

                },
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Financial",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "School Fees",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SchoolFeesScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Bus Fees",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusFeeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Activity Fees",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ActivityFeeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Fees",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformFeeScreen()));

                    },
                  ),

                ],
              ),
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "School Revenue",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Fees",
                    svgSrc: "assets/icons/expense.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RevenueScreen()));

                    },
                  ),
                  role=="Accountant"?Container():DrawerListTile(
                    title: "Discounts",
                    svgSrc: "assets/icons/expense.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DiscountScreen()));

                    },
                  ),
                ],
              ),

              DrawerListTile(
                title: "Expenses",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));

                },
              ),
              DrawerListTile(
                title: "Places",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PlaceScreen()));

                },
              ),
              DrawerListTile(
                title: "Logout",
                svgSrc: "assets/icons/logout.png",
                press: () {
                  FirebaseAuth.instance.signOut().then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SignIn()));
                  });


                },
              )




            ],
          ),
        )
    );
  }
}


class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: Image.asset(
        svgSrc,
        color: Colors.black,
        height: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
