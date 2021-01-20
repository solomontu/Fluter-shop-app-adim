import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import './myHome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return ProviderModel();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // primarySwatch: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHome(),
        // NavigatorRail(),
        // FreshDialogur(),
        //  MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
