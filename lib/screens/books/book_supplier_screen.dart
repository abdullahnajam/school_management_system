import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_system/components/academic/classes/classes.dart';
import 'package:school_management_system/components/academic/departments/departments.dart';
import 'package:school_management_system/components/academic/schools/schools.dart';
import 'package:school_management_system/components/book_center/book%20supplier/book_supplier.dart';
import 'package:school_management_system/components/book_center/books/books.dart';
import 'package:school_management_system/components/employee/employees.dart';
import 'package:school_management_system/navigator/side_menu.dart';
import 'package:school_management_system/utils/responsive.dart';

class BookSupplierScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: BookSupplier(_scaffoldKey),
            ),
          ],
        ),
      ),
    );
  }
}
