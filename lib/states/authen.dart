import 'package:flutter/material.dart';
import 'package:lardgreen/states/create_new_account.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';

import '../widgets/show_button.dart';
import '../widgets/show_form.dart';
import '../widgets/show_text_button.dart';

class Authen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowText(
                lable: 'ลงชื่อใช้งาน',
                textStyle: MyConstant().h1Style(),
              ),
              ShowForm(
                label: 'อีเมล์',
                iconData: Icons.email_outlined,
                changeFunc: (String string) {},
              ),
              ShowForm(
                label: 'รหัสผ่าน',
                iconData: Icons.lock_outline,
                changeFunc: (String string) {},
              ),
              ShowButton(
                label: 'ลงชื่อใช้งาน',
                pressFunc: () {},
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
    );
  }
}
