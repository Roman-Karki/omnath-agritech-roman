import 'package:omnath_agritech_web/constants.dart';
import 'package:omnath_agritech_web/controllers/MenuController.dart';
import 'package:omnath_agritech_web/screens/main/main_screen.dart';
import 'package:omnath_agritech_web/screens/main/providers/tabs_provider.dart';
import 'package:omnath_agritech_web/screens/stock/validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
    
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
          ChangeNotifierProvider(create: (_) => TabsProvider()),
          ChangeNotifierProvider(create: (_) => ProductValidation()),
        ],
        child: MainScreen(),
      ),
    );
  }
}
