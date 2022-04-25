import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/states/main_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    print('Firebase Initial Success');
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainHome(),
    );
  }
}
