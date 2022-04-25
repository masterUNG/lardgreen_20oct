import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_form.dart';
import 'package:lardgreen/widgets/show_text.dart';

import '../widgets/show_title.dart';

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

  String? typeUser;

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
                      changeFunc: (String string) {},
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
                    value: typeUser,
                    items: typeUsers
                        .map(
                          (e) => DropdownMenuItem(
                            child: ShowText(lable: e),
                            value: e,
                          ),
                        )
                        .toList(),
                    hint: ShowText(lable: 'กรุณาเลือกชนิดของสมาชิก'),
                    onChanged: (value) {},
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
                      changeFunc: (String string) {},
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
                      changeFunc: (String string) {},
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
                      changeFunc: (String string) {},
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
