import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/states/create_new_account.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/widgets/show_icon_button.dart';
import 'package:lardgreen/widgets/show_text.dart';

import '../widgets/show_button.dart';
import '../widgets/show_form.dart';
import '../widgets/show_text_button.dart';

class Authen extends StatefulWidget {
  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: ShowIconButton(
            iconData: Icons.arrow_back_ios,
            pressFunc: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeMainHome, (route) => false);
            }),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowText(
                  lable: 'ลงชื่อใช้งาน',
                  textStyle: MyConstant().h1Style(),
                ),
                ShowForm(
                  textInputType: TextInputType.emailAddress,
                  label: 'อีเมล์',
                  iconData: Icons.email_outlined,
                  changeFunc: (String string) {
                    email = string.trim();
                  },
                ),
                ShowForm(
                  obscue: true,
                  label: 'รหัสผ่าน',
                  iconData: Icons.lock_outline,
                  changeFunc: (String string) {
                    password = string.trim();
                  },
                ),
                ShowButton(
                  label: 'ลงชื่อใช้งาน',
                  pressFunc: () {
                    if ((email?.isEmpty ?? true) ||
                        (password?.isEmpty ?? true)) {
                      MyDialog(context: context).normalDialog(
                          title: 'มีช่องว่าง',
                          message: 'กรุณากรอกให้ครบทุกช่อง');
                    } else {
                      processCheckAuthen();
                    }
                  },
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTextButton(
                        label: 'ลืมรหัสผ่าน',
                        pressFunc: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ShowText(lable: 'ไม่มีชื่อผู้ใช้งาน?'),
                      ShowTextButton(
                        label: 'สมัครใช้งาน',
                        pressFunc: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewAccount(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processCheckAuthen() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) async {
        UserModle userModle = UserModle.fromMap(value.data()!);

        print('## userModel ==> ${userModle.toMap()}');

        switch (userModle.status) {
          case 'wait':
            await FirebaseAuth.instance.signOut().then(
              (value) {
                MyDialog(context: context).normalDialog(
                    presFunc: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    title: 'สถานะเป็น${userModle.status}',
                    message: 'กรุณารอให้ Admin Approve ก่อนครับ');
              },
            );

            break;
          case 'approve':
            if (userModle.typeUser == 'buyer') {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeMainHome, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeSellerService, (route) => false);
            }

            break;
          default:
        }
      });
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, message: onError.nmessage);
    });
  }
}
