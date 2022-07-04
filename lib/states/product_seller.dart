// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/product_model.dart';
import 'package:lardgreen/states/add_new_product.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';

import 'package:lardgreen/widgets/show_title.dart';

import '../utility/my_dialog.dart';
import '../widgets/show_icon_button.dart';

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
  var productModels = <ProductModel>[];

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    readProductData();
  }

  Future<void> readProductData() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
    }
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
        for (var item in value.docs) {
          ProductModel productModel = ProductModel.fromMap(item.data());
          productModels.add(productModel);
        }
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
              ? newContent()
              : Center(
                  child: ShowText(
                    lable: 'ยังไม่มีสินค้า',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }

  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          children: [
            ShowTitle(title: 'จัดการสินค้า'),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: productModels.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: constarints.maxWidth * 0.5 - 8,
                        height: 120,
                        margin: EdgeInsets.all(8),
                        child: Image.network(
                          productModels[index].urlProduct,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: constarints.maxWidth * 0.5 - 8,
                        height: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShowText(
                              lable: productModels[index].name,
                              textStyle: MyConstant().h2Style(),
                            ),
                            ShowText(
                              lable:
                                  "ราคา ${productModels[index].price.toString()} บาท/${productModels[index].unit}",
                              textStyle: MyConstant().h3Style(),
                            ),
                            ShowText(
                              lable:
                                  "สต็อก ${productModels[index].stock.toString()} ${productModels[index].unit}",
                              textStyle: MyConstant().h3Style(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ShowIconButton(
                                    iconData: Icons.edit,
                                    pressFunc: () {
                                      MyDialog(context: context).actionDialog(
                                          title: 'ยืนยันการแก้ไข',
                                          message: 'คุณต้องการแก้ไขสินค้านี้',
                                          label1: 'แก้ไขสินค้า',
                                          label2: 'ยกเลิก',
                                          presFunc1: () {
                                            Navigator.pop(context);
                                          },
                                          presFunc2: () {
                                            Navigator.pop(context);
                                          });
                                    }),
                                ShowIconButton(
                                    iconData: Icons.delete_forever,
                                    pressFunc: () {
                                      MyDialog(context: context).actionDialog(
                                          title: 'ยืนยันการลบ',
                                          message: 'คุณต้องการลบสินค้านี้',
                                          label1: 'ลบสินค้า',
                                          label2: 'ยกเลิก',
                                          presFunc1: () {
                                            Navigator.pop(context);
                                          },
                                          presFunc2: () {
                                            Navigator.pop(context);
                                          });
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: MyConstant.dark,
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
