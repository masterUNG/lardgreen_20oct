import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_form.dart';
import 'package:lardgreen/widgets/show_text.dart';

import '../widgets/show_title.dart';
import 'main_home.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  var typeUsers = <String>[
    'buyer',
    'seller',
  ];

  var typeUserThs = <String>[
    'ผู้ซื้อ',
    'ผู้ขาย',
  ];

  var indexs = <int>[
    0,
    1,
  ];

  int? indexType;

  String? name, email, password, address, phone, token;

  @override
  void initState() {
    super.initState();
    findToken();
  }

  Future<void> findToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    token = await firebaseMessaging.getToken();
    print('token ==> $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'สมัครสมาชิกใหม่',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(
          FocusScopeNode(),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowForm(
                      label: 'ชื่อ',
                      iconData: Icons.fingerprint,
                      changeFunc: (String string) {
                        name = string.trim();
                      },
                    )),
              ],
            ),
            const ShowTitle(
              title: 'ชนิดสมาชิก:',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: DropdownButton<dynamic>(
                    value: indexType,
                    items: indexs
                        .map(
                          (e) => DropdownMenuItem(
                            child: ShowText(lable: typeUserThs[e]),
                            value: e,
                          ),
                        )
                        .toList(),
                    hint: ShowText(lable: 'กรุณาเลือกชนิดของสมาชิก'),
                    onChanged: (value) {
                      indexType = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowForm(
                      textInputType: TextInputType.emailAddress,
                      label: 'อีเมล์',
                      iconData: Icons.email_outlined,
                      changeFunc: (String string) {
                        email = string.trim();
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowForm(
                      label: 'รหัสผ่าน',
                      iconData: Icons.lock_outline,
                      changeFunc: (String string) {
                        password = string.trim();
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowForm(
                      label: 'ที่อยู่',
                      iconData: Icons.home,
                      changeFunc: (String string) {
                        address = string.trim();
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowForm(
                      textInputType: TextInputType.phone,
                      label: 'เบอร์โทรศัพท์',
                      iconData: Icons.phone,
                      changeFunc: (String string) {
                        phone = string.trim();
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ShowButton(
                    label: 'Create New Account',
                    pressFunc: () {
                      if (indexType == null) {
                        MyDialog(context: context).normalDialog(
                            title: 'ยังไม่เลือกชนิดสมาชิก',
                            message: 'โปรดเลือกชนิดสมาชิก');
                      } else if ((name?.isEmpty ?? true) ||
                          (email?.isEmpty ?? true) ||
                          (password?.isEmpty ?? true) ||
                          (phone?.isEmpty ?? true) ||
                          (address?.isEmpty ?? true)) {
                        MyDialog(context: context).normalDialog(
                            title: 'มีช่องว่าง',
                            message: 'กรุณากรอก ทุกช่อง ครับ');
                      } else {
                        processCreateNewAccount();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processCreateNewAccount() async {
    String status = 'wait';
    if (typeUsers[indexType!] == typeUsers[0]) {
      status = 'approve';
    }

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;
      UserModle userModle = UserModle(
        address: address!,
        email: email!,
        name: name!,
        password: password!,
        phone: phone!,
        status: status,
        token: token!,
        typeUser: typeUsers[indexType!],
      );
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(userModle.toMap())
          .then((value) {
        if (typeUsers[indexType!] == typeUsers[0]) {
          MyDialog(context: context).normalDialog(
              presFunc: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              title: 'สมัครสมาชิก สำเร็จ',
              message: 'ยินดีต้อนรับสู่แอปหลาดกรีน คุณสามารถเข้าใช้งานได้ครับ');
        } else {
          MyDialog(context: context).normalDialog(
              presFunc: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainHome(),
                    ),
                    (route) => false);
              },
              title: 'สมัครสมาชิก สำเร็จ',
              message: 'กรุณารอการตรวจสอบ จาก Admin');
        }
      });
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, message: onError.message);
    });
  }
}
