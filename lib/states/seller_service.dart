import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/states/order_seller.dart';
import 'package:lardgreen/states/product_seller.dart';
import 'package:lardgreen/states/profile_seller.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_menu.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';

import '../widgets/show_signout.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  bool load = true;

  var widgets = <Widget>[];
  var user = FirebaseAuth.instance.currentUser;
  UserModle? userModle;
  int indexWidget = 0;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<void> findUser() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      userModle = UserModle.fromMap(value.data()!);
      load = false;
      widgets.add(
        OrderSeller(
          docIdUser: user!.uid,
        ),
      );
      widgets.add(
        ProfileSeller(
          docIdUser: user!.uid,
        ),
      );
      widgets.add(
        ProductSeller(
          docIdUser: user!.uid,
        ),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: ShowText(
          lable: 'ส่วนร้านค้า',
          textStyle: MyConstant().h2Style(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: userModle == null
                  ? SizedBox(
                      child: ShowImage(),
                    )
                  : userModle!.urlAvatar!.isEmpty
                      ? const ShowImage(path: 'images/shop.png')
                      : Image.network(userModle!.urlAvatar!),
              decoration:
                  BoxDecoration(color: MyConstant.light.withOpacity(0.5)),
              accountName: ShowText(
                lable: userModle == null ? '' : userModle!.name,
                textStyle: MyConstant().h2Style(),
              ),
              accountEmail: ShowText(
                lable: userModle == null ? '' : userModle!.email,
                textStyle: MyConstant().h3Style(),
              ),
            ),
            ShowMenu(
              title: 'รายการสั่งของ',
              subTitle: 'Order List',
              iconData: Icons.shopping_basket,
              tapFunc: () {
                indexWidget = 0;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ShowMenu(
              title: 'จัดการหน้าร้าน',
              subTitle: 'Edit Profile',
              iconData: Icons.shop,
              tapFunc: () {
                indexWidget = 1;
                Navigator.pop(context);

                setState(() {});
              },
            ),
            ShowMenu(
              title: 'จัดการสินค้า',
              subTitle: 'Manage Product',
              iconData: Icons.production_quantity_limits,
              tapFunc: () {
                indexWidget = 2;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            Spacer(),
            ShowSignOut(),
          ],
        ),
      ),
      body: load ? const ShowProgress() : widgets[indexWidget],
    );
  }
}
