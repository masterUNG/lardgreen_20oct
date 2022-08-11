// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/order_product_model.dart';
import 'package:lardgreen/models/product_model.dart';
import 'package:lardgreen/models/slip_model.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_progress.dart';

class CheckSlip extends StatefulWidget {
  final String docIdOrder;

  const CheckSlip({
    Key? key,
    required this.docIdOrder,
  }) : super(key: key);

  @override
  State<CheckSlip> createState() => _CheckSlipState();
}

class _CheckSlipState extends State<CheckSlip> {
  String? docIdOrder;
  SlipModel? slipModel;

  @override
  void initState() {
    super.initState();
    docIdOrder = widget.docIdOrder;
    readSlip();
  }

  Future<void> readSlip() async {
    await FirebaseFirestore.instance
        .collection('order')
        .doc(docIdOrder)
        .collection('slip')
        .get()
        .then((value) {
      for (var element in value.docs) {
        slipModel = SlipModel.fromMap(element.data());
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: slipModel == null
          ? const ShowProgress()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(slipModel!.urlSlip),
                  ShowButton(
                    label: 'ตัดยอด',
                    pressFunc: () {
                      processCutStock();
                    },
                  )
                ],
              ),
            ),
    );
  }

  Future<void> processCutStock() async {
    await FirebaseFirestore.instance
        .collection('order')
        .doc(docIdOrder)
        .get()
        .then((value) async {
      OrderProductModel orderProductModel =
          OrderProductModel.fromMap(value.data()!);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(orderProductModel.uidSeller)
          .collection('product')
          .doc(orderProductModel.docIdProducts[0])
          .get()
          .then((value) async {
        ProductModel productModel = ProductModel.fromMap(value.data()!);
        int oldStock = productModel.stock;

        int orderStock = int.parse(orderProductModel.amountProducts[0]);

        print('oldStock ==> $oldStock, orderStock ==> $orderStock');

        Map<String, dynamic> map = productModel.toMap();
        map['stock'] = oldStock - orderStock;

        await FirebaseFirestore.instance
            .collection('user')
            .doc(orderProductModel.uidSeller)
            .collection('product')
            .doc(orderProductModel.docIdProducts[0])
            .update(map)
            .then((value) async {
          Map<String, dynamic> map2 = productModel.toMap();
          map2['status'] = 'delivery';

          await FirebaseFirestore.instance
              .collection('order')
              .doc(docIdOrder)
              .update(map2)
              .then((value) {
                Navigator.pop(context);
              });
        });
      });
    });
  }
}
