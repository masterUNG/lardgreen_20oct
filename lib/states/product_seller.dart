// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/states/add_new_product.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';

import 'package:lardgreen/widgets/show_title.dart';

class ProductSeller extends StatefulWidget {
  final String docIdUser;

  const ProductSeller({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<ProductSeller> createState() => _ProductSellerState();
}

class _ProductSellerState extends State<ProductSeller> {
  bool load = true;
  String? docIdUser;
  bool? haveProduct;

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    readProductData();
  }

  Future<void> readProductData() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .collection('product')
        .get()
        .then((value) {
      print('value ==> ${value.docs}');
      load = false;

      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ShowButton(
          label: 'เพิ่มสินค้า',
          pressFunc: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewProduct(),
                )).then((value) => readProductData());
          }),
      body: load
          ? const ShowProgress()
          : haveProduct!
              ? ShowTitle(
                  title: 'จัดการสินค้า',
                )
              : Center(
                  child: ShowText(
                    lable: 'ยังไม่มีสินค้า',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }
}
