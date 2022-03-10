import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_system/components/academic/classes/classes.dart';
import 'package:school_management_system/components/academic/departments/departments.dart';
import 'package:school_management_system/components/academic/schools/schools.dart';
import 'package:school_management_system/components/activities/activities.dart';
import 'package:school_management_system/components/employee/employees.dart';
import 'package:school_management_system/components/uniform_center/uniform_attribute_values/uniform_attribute_value.dart';
import 'package:school_management_system/components/uniform_center/uniform_attributes/uniform_attribute.dart';
import 'package:school_management_system/components/uniform_center/unifrom_category/uniform_category.dart';
import 'package:school_management_system/model/uniform/uniform_attribute_model.dart';
import 'package:school_management_system/navigator/side_menu.dart';
import 'package:school_management_system/utils/responsive.dart';

class AttributeValueScreen extends StatelessWidget {
  UniformAttributeModel attributeModel;

  AttributeValueScreen(this.attributeModel);

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
              child: UniformAttributeValue(_scaffoldKey,attributeModel),
            ),
          ],
        ),
      ),
    );
  }
}
