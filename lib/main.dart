import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_management_system/provider/UserDataProvider.dart';
import 'package:school_management_system/screens/academic/department_screen.dart';
import 'package:school_management_system/screens/academic/school_screen.dart';
import 'package:school_management_system/screens/signin.dart';
import 'package:school_management_system/screens/uniform/uniform_delivery_screen.dart';
import 'package:school_management_system/utils/constants.dart';

import 'components/uniform_center/uniform_delivery/uniform_add_delivery_items.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdminProvider>(
          create: (_) => AdminProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Management System',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: bgColor,
          primaryColor: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          //canvasColor: secondaryColor,
        ),
        home: FirebaseAuth.instance.currentUser!=null?UniformDeliveryScreen():SignIn(),
      ),
    );
  }
}
