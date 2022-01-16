import 'package:flutter/material.dart';
import 'package:school_management_system/components/reports/income/revenue_detail/department/department_revenue.dart';
import 'package:school_management_system/components/reports/income/revenue_detail/school/school_revenue.dart';
import 'package:school_management_system/navigator/side_menu.dart';
import 'package:school_management_system/utils/responsive.dart';

class DepartmentReportScreen extends StatelessWidget {
  String type,schoolId;

  DepartmentReportScreen(this.type,this.schoolId);

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
              child: DepartmentRevenue(_scaffoldKey,type,schoolId),
            ),
          ],
        ),
      ),
    );
  }
}
