import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/states/about_me.dart';
import 'package:lardgreen/states/authen.dart';
import 'package:lardgreen/states/helper.dart';
import 'package:lardgreen/states/home.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_signout.dart';
import 'package:lardgreen/widgets/show_text.dart';

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

  var widgetGuests = <Widget>[];
  var widgetBuyer = <Widget>[];
  var widgets = <Widget>[];
  int indexWidget = 0;
  var user = FirebaseAuth.instance.currentUser;
  UserModle? userModle;

  @override
  void initState() {
    super.initState();

    widgetGuests.add(const Home());
    widgetGuests.add(const Helper());
    widgetGuests.add(const AboutMe());

    widgetBuyer.add(const Home());

    readDataUser();
  }

  Future<void> readDataUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event == null) {
        logined = false;
        widgets = widgetGuests;
      } else {
        logined = true;
        widgets = widgetBuyer;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user!.uid)
            .get()
            .then((value) {
          userModle = UserModle.fromMap(value.data()!);
        });
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
      drawer: load
          ? null
          : logined!
              ? drawerBuyer(context)
              : drawerGuest(context),
      body: load ? const ShowProgress() : widgets[indexWidget],
    );
  }

  Drawer drawerGuest(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const ShowImage(),
            decoration: BoxDecoration(
              color: MyConstant.light.withOpacity(0.5),
            ),
            accountName: ShowText(
              lable: 'ยังไม่ได้ลงชื่อใช้งาน',
              textStyle: MyConstant().h3Style(),
            ),
            accountEmail: ShowText(
              lable: 'กรุณาลงชื่อใช้งาน โดยคลิกที่สมาชิก',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ShowMenu(
              title: 'Home',
              iconData: Icons.home_outlined,
              tapFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexWidget = 0;
                });
              }),
          ShowMenu(
              title: 'คู่มือการใช้งาน',
              iconData: Icons.manage_search_outlined,
              tapFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexWidget = 1;
                });
              }),
          ShowMenu(
              title: 'เกี่ยวกับ',
              iconData: Icons.album_outlined,
              tapFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexWidget = 2;
                });
              }),
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
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: MyConstant.light.withOpacity(0.5),
            ),
            currentAccountPicture: ShowImage(),
            accountName: ShowText(
              lable: userModle!.name,
              textStyle: MyConstant().h2Style(),
            ),
            accountEmail: ShowText(
              lable: userModle!.email,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          ShowMenu(
              title: 'Home',
              iconData: Icons.home_outlined,
              tapFunc: () {
                Navigator.pop(context);
                setState(() {
                  indexWidget = 0;
                });
              }),
          const Spacer(),
          const ShowSignOut(),
        ],
      ),
    );
  }
}
