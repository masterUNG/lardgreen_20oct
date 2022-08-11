// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/widgets/show_icon_button.dart';

import '../models/order_product_model.dart';
import '../models/user_model.dart';
import '../utility/my_constant.dart';
import '../widgets/show_progress.dart';
import '../widgets/show_text.dart';
import '../widgets/show_title.dart';

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
  var userModels = <UserModle>[];
  List<List<Widget>> listWidget = [];
  var docIdOrders = <String>[];

  final statuss = MyConstant.statuss;

  @override
  void initState() {
    super.initState();
    readMyOrder();
  }

  Future<void> readMyOrder() async {
   
      orderProductModels.clear();
      docIdOrders.clear();
      userModels.clear();
      listWidget.clear();
    

    var user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    print('## uid ==> $uid');

    await FirebaseFirestore.instance
        .collection('order')
        .where('uidSeller', isEqualTo: uid)
        .get()
        .then((value) async {
      load = false;
      if (value.docs.isEmpty) {
        haveOrder = false;
      } else {
        haveOrder = true;

        for (var item in value.docs) {
          OrderProductModel model = OrderProductModel.fromMap(item.data());
          orderProductModels.add(model);
          docIdOrders.add(item.id);

          var widgets = <Widget>[];
          for (var i = 0; i < model.docIdProducts.length; i++) {
            widgets.add(
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ShowText(lable: model.nameProducts[i]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(lable: model.priceProducts[i]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(lable: model.amountProducts[i]),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowText(lable: model.sumProducts[i]),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          listWidget.add(widgets);

          await FirebaseFirestore.instance
              .collection('user')
              .doc(model.uidBuyer)
              .get()
              .then((value) {
            UserModle userModle = UserModle.fromMap(value.data()!);
            userModels.add(userModle);
          });
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : haveOrder!
            ? newContent()
            : Center(
                child: ShowText(
                lable: 'ไม่มีรายการ สั่งซื้อ',
                textStyle: MyConstant().h1Style(),
              ));
  }

  Widget newContent() => ListView(
        children: [
          const ShowTitle(title: 'รายการสั่งซื่อ'),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: orderProductModels.length,
            itemBuilder: (context, index) => ExpansionTile(
              children: listWidget[index],
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShowTitle(title: 'ผู้ซื้อ:${userModels[index].name}'),
                      ShowText(
                          lable: 'สถานะ:${orderProductModels[index].status}'),
                      orderProductModels[index].status == 'order'
                          ? ShowIconButton(
                              iconData: Icons.edit_outlined,
                              pressFunc: () {
                                // print('you  click ==> $index');

                                Map<String, dynamic> map = {};
                                MyDialog(context: context).actionDialog(
                                  cancleButton: true,
                                  title: 'เลือกสถานะใหม่',
                                  message:
                                      'กรุณาเลือก แจ้งชำระสินค้า หรือ ยกเลิกคำสั่งซื้อ',
                                  label1: 'แจ้งชำระสินค้า',
                                  label2: 'ยกเลิกคำสั่งซื้อ',
                                  presFunc1: () {
                                    map['status'] = 'confirm';
                                    Navigator.pop(context);
                                    processChangeStatus(
                                        docIdOrder: docIdOrders[index],
                                        map: map,
                                        docIdBuyer:
                                            orderProductModels[index].uidBuyer);
                                  },
                                  presFunc2: () {
                                    map['status'] = 'cancel';
                                    Navigator.pop(context);
                                    processChangeStatus(
                                        docIdOrder: docIdOrders[index],
                                        map: map,
                                        docIdBuyer:
                                            orderProductModels[index].uidBuyer);
                                  },
                                );
                              },
                            )
                          : orderProductModels[index].status == statuss[1]
                              ? ShowIconButton(
                                  iconData: Icons.money,
                                  pressFunc: () {
                                    MyDialog(context: context).normalDialog(
                                        title: 'สถาณะ Payment',
                                        message: 'รอให้ ลูกค้าชำระสินค้าก่อน');
                                  })
                              : orderProductModels[index].status == statuss[2]
                                  ? ShowIconButton(
                                      iconData: Icons.attach_money_outlined,
                                      pressFunc: () {})
                                  : orderProductModels[index].status ==
                                          statuss[3]
                                      ? ShowIconButton(
                                          iconData: Icons.train_sharp,
                                          pressFunc: () {
                                             MyDialog(context: context)
                                                    .normalDialog(
                                                        title: 'Delivery',
                                                        message:
                                                            'อยู่ระหว่างการจัดส่งสินค้า');
                                          })
                                      : orderProductModels[index].status ==
                                              statuss[4]
                                          ? ShowIconButton(
                                              iconData: Icons.face_outlined,
                                              pressFunc: () {
                                               
                                              })
                                          : orderProductModels[index].status ==
                                                  statuss[5]
                                              ? ShowIconButton(
                                                  iconData: Icons.cancel,
                                                  pressFunc: () {
                                                    MyDialog(context: context)
                                                        .normalDialog(
                                                            title:
                                                                'ยกเลิกสินค้า',
                                                            message:
                                                                'สินค้านี่ยกเลิกไปแล้ว');
                                                  })
                                              : const SizedBox(),
                    ],
                  ),
                  Row(
                    children: [
                      ShowTitle(title: 'สถานที่จัดส่ง'),
                      ShowText(lable: orderProductModels[index].delivery),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Future<void> processChangeStatus(
      {required String docIdOrder,
      required Map<String, dynamic> map,
      required String docIdBuyer}) async {
    await FirebaseFirestore.instance
        .collection('order')
        .doc(docIdOrder)
        .update(map)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docIdBuyer)
          .get()
          .then((value) async {
        UserModle modle = UserModle.fromMap(value.data()!);
        String token = modle.token;
        String title = 'รายการสั่งสินค้า ${map['status']}';
        String body = 'ขอบคุณครับ';

        String path =
            'https://www.androidthai.in.th/bigc/noti/apiNotilardgreen.php?isAdd=true&token=$token&title=$title&body=$body';

        await Dio().get(path).then((value) {
          readMyOrder();
        });
      });
     
    });
  }
}