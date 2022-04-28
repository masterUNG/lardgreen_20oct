// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lardgreen/models/product_model.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_form.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

class ShowDetailProduct extends StatefulWidget {
  final String docIdUser;
  final String docIdProduct;
  final ProductModel productModel;

  const ShowDetailProduct({
    Key? key,
    required this.docIdUser,
    required this.docIdProduct,
    required this.productModel,
  }) : super(key: key);

  @override
  State<ShowDetailProduct> createState() => _ShowDetailProductState();
}

class _ShowDetailProductState extends State<ShowDetailProduct> {
  String? docIdUser, docIdProduct;
  ProductModel? productModel;
  bool load = true;
  UserModle? userModle;

  @override
  void initState() {
    super.initState();
    docIdUser = widget.docIdUser;
    docIdProduct = widget.docIdProduct;
    productModel = widget.productModel;
    readSeller();
  }

  Future<void> readSeller() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docIdUser)
        .get()
        .then((value) {
      userModle = UserModle.fromMap(value.data()!);
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(lable: load ? '' : 'ร้านค้า ${userModle!.name}'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: constraints.maxWidth,
                height: constraints.maxWidth * 0.75,
                child: Image.network(
                  productModel!.urlProduct,
                  fit: BoxFit.cover,
                ),
              ),
              newDetail(head: 'ชื่อสินค้า : ' '', value: productModel!.name),
              newDetail(
                  head: 'ราคา',
                  value: '${productModel!.price} บาท/${productModel!.unit}'),
              newDetail(
                  head: 'สต็อก',
                  value: '${productModel!.stock} ${productModel!.unit}'),
              newDetail(head: 'รายละเอียด', value: '${productModel!.detail}'),
              Row(
                children: [
                  ShowTitle(title: 'จำนวนที่สั่ง :'),
                  ShowForm(
                      textInputType: TextInputType.number,
                      label: 'จำนวนที่สั่ง',
                      iconData: Icons.book,
                      changeFunc: (String string) {}),
                ],
              ),
              ShowButton(label: 'ใส่ตระกล้า', pressFunc: () {}),
            ],
          ),
        );
      }),
    );
  }

  Row newDetail({required String head, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1, //screen ratio
          child: ShowTitle(title: head),
        ),
        Expanded(
          flex: 2,
          child: ShowText(lable: value),
        ),
      ],
    );
  }
}
