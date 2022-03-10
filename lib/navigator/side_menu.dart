
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management_system/components/student/student_popup.dart';
import 'package:school_management_system/components/uniform_center/uniform_attributes/uniform_attribute.dart';
import 'package:school_management_system/model/uniform/uniform_category_model.dart';
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
import 'package:school_management_system/screens/books/book_supplier_screen.dart';
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
import 'package:school_management_system/screens/parent_screen.dart';
import 'package:school_management_system/screens/places/place_screen.dart';
import 'package:school_management_system/screens/reports/income/income_screen.dart';
import 'package:school_management_system/screens/revenue_screen.dart';
import 'package:school_management_system/screens/signin.dart';
import 'package:school_management_system/screens/staff_screen.dart';
import 'package:school_management_system/screens/student_screen.dart';
import 'package:school_management_system/screens/supply/supply_delivery_screen.dart';
import 'package:school_management_system/screens/supply/supply_items_screen.dart';
import 'package:school_management_system/screens/supply/supply_stock_screen.dart';
import 'package:school_management_system/screens/supply/supply_supplier_screen.dart';
import 'package:school_management_system/screens/supply/supply_variation_screen.dart';
import 'package:school_management_system/screens/teacher_screen.dart';
import 'package:school_management_system/screens/transfer_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_Supplier_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_attribute_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_category_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_delivery_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_items_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_low_stock_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_stock_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_variation_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String roleName="";
  List roles=[];
  bool isLoaded=false;
  @override
  void initState() {
    super.initState();
    isLoaded=true;
    print("user id ${FirebaseAuth.instance.currentUser!.uid}");
    FirebaseFirestore.instance.collection('admins').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        FirebaseFirestore.instance.collection('roles').doc(data['roleId']).get().then((DocumentSnapshot roleSnapshot) {
          if (roleSnapshot.exists) {
            Map<String, dynamic> role = roleSnapshot.data() as Map<String, dynamic>;
            setState(() {
              roles=role['access'];
              roleName=role['role'];
              isLoaded=true;
            });

          }
        });


      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return !isLoaded?Center(child: CircularProgressIndicator(),):Drawer(

        child: Container(
          color: bgColor,
          child:ListView(
            children: [
              DrawerHeader(
                child: Image.asset("assets/images/logo.png"),
              ),

              roles.contains("Administration")?DrawerListTile(
                title: "Administration",
                svgSrc: "assets/icons/school.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminScreen()));

                },
              ):Container(),
              roles.contains("Academic")?ExpansionTile(
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
              ):Container(),
              roles.contains("Teachers")?DrawerListTile(
                title: "Teachers",
                svgSrc: "assets/icons/teacher.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherScreen()));

                },
              ):Container(),

              roles.contains("Employees")?DrawerListTile(
                title: "Employees",
                svgSrc: "assets/icons/employee.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmployeeScreen()));

                },
              ):Container(),
              roles.contains("Staff")?DrawerListTile(
                title: "Staff",
                svgSrc: "assets/icons/department.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StaffScreen()));

                },
              ):Container(),
              roles.contains("Students")?DrawerListTile(
                title: "Students",
                svgSrc: "assets/icons/students.png",
                press: () {
                  showStudentListDialog(context);

                },
              ):Container(),
              roles.contains("Parents")?DrawerListTile(
                title: "Parents",
                svgSrc: "assets/icons/students.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ParentScreen()));

                },
              ):Container(),
              roles.contains("Book Center")?ExpansionTile(
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
                    title: "Book Supplier",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookSupplierScreen()));

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
              ):Container(),
              roles.contains("Uniform Center")?ExpansionTile(
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
                    title: "Uniform Attribute",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformAttributeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Category",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformCategoryScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Low Stock Items",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformLowStockScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Uniform Items",
                    svgSrc: "assets/icons/school.png",
                    press: () async{
                      List<String> list=[];
                      list.add("All Categories");
                      final ProgressDialog pr = ProgressDialog(context: context);
                      pr.show(max: 100, msg: "Please wait");
                      await FirebaseFirestore.instance
                          .collection('uniform_categories')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                          setState(() {
                            list.add(UniformCategoryModel.fromMap(data, doc.reference.id).name);
                          });
                        });
                      });
                      pr.close();
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UniformItemsScreen(list)));


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
              ):Container(),
              roles.contains("Supply Center")?ExpansionTile(
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
              ):Container(),
              roles.contains("School Busses")?ExpansionTile(
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
              ):Container(),
              roles.contains("Activity")?DrawerListTile(
                title: "Activity",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ActivityScreen()));

                },
              ):Container(),
              roles.contains("Transfer")?DrawerListTile(
                title: "Transfer",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TransferScreen()));

                },
              ):Container(),
              roles.contains("Financial")?ExpansionTile(
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
              ):Container(),
              roles.contains("School Revenue")?ExpansionTile(
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
                  roleName=="Accountant"?Container():DrawerListTile(
                    title: "Discounts",
                    svgSrc: "assets/icons/expense.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DiscountScreen()));

                    },
                  ),
                ],
              ):Container(),

              roles.contains("Expenses")?DrawerListTile(
                title: "Expenses",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpenseScreen()));

                },
              ):Container(),
              roles.contains("Reports")?ExpansionTile(
                leading: Image.asset(
                  "assets/icons/home.png",
                  color: Colors.black,
                  height: 20,
                ),
                title: Text(
                  "Report",
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  DrawerListTile(
                    title: "Income",
                    svgSrc: "assets/icons/department.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => IncomeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Revenue",
                    svgSrc: "assets/icons/school.png",
                    press: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BusFeeScreen()));

                    },
                  ),
                  DrawerListTile(
                    title: "Expenses",
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
              ):Container(),
              roles.contains("Places")?DrawerListTile(
                title: "Places",
                svgSrc: "assets/icons/expense.png",
                press: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PlaceScreen()));

                },
              ):Container(),


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
