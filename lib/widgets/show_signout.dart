import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_menu.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.5),
      ),
      child: ShowMenu(
        title: 'ออกจากระบบ',
        subTitle: 'Signout',
        iconData: Icons.exit_to_app,
        tapFunc: () async {
          FirebaseAuth.instance.signOut().then(
            (value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeMainHome, (route) => false);
            },
          );
        },
      ),
    );
  }
}
