
import 'package:flutter/cupertino.dart';
import 'package:school_management_system/model/admin_model.dart';

class AdminProvider extends ChangeNotifier {
  AdminModel? adminData;
  void setUserData(AdminModel admin) {
    this.adminData = admin;
    notifyListeners();
  }
}
