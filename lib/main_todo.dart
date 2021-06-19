import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_family/page/home_page.dart';
import 'package:my_family/provider/todos.dart';

Future maintodo() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Todo App With Firebase';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TodosProvider(),
    child: Consumer<TodosProvider>(
    builder: (context, provider, child) =>  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.pink,
              scaffoldBackgroundColor: Color(0xFFf6f5ee),
            ),
            home: HomePage(),

          ),


    )
    );
  }
}
