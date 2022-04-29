// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/order_product_model.dart';
import 'package:lardgreen/utility/my_calculate.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';

import 'package:lardgreen/widgets/show_title.dart';

class OrderSeller extends StatefulWidget {
  final String docIdUser;

  const OrderSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<OrderSeller> createState() => _OrderSellerState();
}

class _OrderSellerState extends State<OrderSeller> {
  bool load = true;
  bool? haveOrder;
  var orderProductModels = <OrderProductModel>[];

  @override
  void initState() {
    super.initState();
    readMyOrder();
  }

  Future<void> readMyOrder() async {

    if (orderProductModels.isNotEmpty) {
      orderProductModels.clear();
    }
    var user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    

    await FirebaseFirestore.instance
        .collection('order')
        .where('uidSeller', isEqualTo: uid)
        .get()
        .then((value) {
      load = false;
      if (value.docs.isEmpty) {
        haveOrder = false;
      } else {
        haveOrder = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? const ShowTitle(title: 'รายการสั่งซื้อ')
            : Center(
              child: ShowText(
                  lable: 'ยังไม่มีรายการสั่งซื้อ',
                  textStyle: MyConstant().h1Style(),
                ),
            );
  }
}
