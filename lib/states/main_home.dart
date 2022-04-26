import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/states/authen.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_signout.dart';

import '../widgets/show_menu.dart';

class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool load = true;
bool? logined;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<void> readDataUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        logined = false;
      } else {
        logined = true;
      }
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      drawer: logined! ? drawerBuyer(context) : drawerGuest(context),
    );
  }

  Drawer drawerGuest(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          const Spacer(),
          ShowMenu(
            subTitle: 'ลงชื่อใช้งาน หรือสมัครสมาชิก',
            title: 'สมาชิก',
            iconData: Icons.card_membership,
            tapFunc: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authen(),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Drawer drawerBuyer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          const Spacer(),
          ShowSignOut(),
        ],
      ),
    );
  }
}
