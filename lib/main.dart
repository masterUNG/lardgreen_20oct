import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/states/main_home.dart';
import 'package:lardgreen/states/seller_service.dart';
import 'package:lardgreen/statewebsites/home_page.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb; //check run on web

final Map<String, WidgetBuilder> map = {
  MyConstant.routeMainHome: (context) => const MainHome(),
  MyConstant.routeHomePage: (context) => const HomePage(),
  MyConstant.routeSellerService: (context) => const SellerService(),
};

String? firstPage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    if (kIsWeb) {
      firstPage = MyConstant.routeHomePage;
      runApp(const MyApp());
    } else {
      firstPage = MyConstant.routeMainHome;
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          String uid = event.uid;
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .get()
              .then((value) {
            UserModle userModle = UserModle.fromMap(value.data()!);
            switch (userModle.typeUser) {
              case 'buyer':
                firstPage = MyConstant.routeMainHome;
                runApp(const MyApp());
                break;
              case 'seller':
                firstPage = MyConstant.routeSellerService;
                runApp(const MyApp());
                break;
              default:
            }
          });
        } else {
          
          firstPage = MyConstant.routeMainHome;
          runApp(const MyApp());
        }
      });
    }

  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: firstPage,
      title: 'LardGreen',
    );
  }
}
