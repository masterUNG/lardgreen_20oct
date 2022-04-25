import 'package:flutter/material.dart';
import 'package:lardgreen/states/authen.dart';
import 'package:lardgreen/utility/my_constant.dart';

import '../widgets/show_menu.dart';

class MainHome extends StatelessWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      drawer: Drawer(
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
      ),
    );
  }
}
