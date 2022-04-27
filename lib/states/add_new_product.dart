import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lardgreen/models/product_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_form.dart';
import 'package:lardgreen/widgets/show_icon_button.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  DateTime dateTime = DateTime.now();
  String? showDateTime, name, price, unit, stock, detail;
  File? file;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');
    showDateTime = dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'เพิ่มสินค้า',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          children: [
            ShowTitle(title: 'วันเวลาที่ เพิ่มสินค้า'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 250,
                    child: ShowText(
                      lable: showDateTime!,
                      textStyle: MyConstant().h2Style(),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  margin: const EdgeInsets.symmetric(
                    vertical: 36,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: file == null
                            ? ShowImage(
                                path: 'images/product.png',
                              )
                            : Image.file(file!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ShowIconButton(
                          iconData: Icons.add_a_photo,
                          pressFunc: () {
                            MyDialog(context: context).actionDialog(
                                title: 'ถ่ายสินค้า',
                                message:
                                    'โดยการถ่ายรูป หรือ เลือกรูปจากคลังภาพ',
                                label1: 'ถ่ายรูป',
                                label2: 'คลังภาพ',
                                presFunc1: () {
                                  processTakePhoto(source: ImageSource.camera);
                                },
                                presFunc2: () {
                                  processTakePhoto(source: ImageSource.gallery);
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowForm(
                  label: 'ชื่อสินค้า',
                  iconData: Icons.book,
                  changeFunc: (String string) {
                    name = string.trim();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowForm(
                  textInputType: TextInputType.number,
                  label: 'ราคา',
                  iconData: Icons.price_change_outlined,
                  changeFunc: (String string) {
                    price = string.trim();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowForm(
                  label: 'หน่วยสินค้า',
                  iconData: Icons.ac_unit,
                  changeFunc: (String string) {
                    unit = string.trim();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowForm(
                  textInputType: TextInputType.number,
                  label: 'สต็อก',
                  iconData: Icons.abc_sharp,
                  changeFunc: (String string) {
                    stock = string.trim();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowForm(
                  label: 'รายละเอียด',
                  iconData: Icons.details,
                  changeFunc: (String string) {
                    detail = string.trim();
                  },
                ),
              ],
            ),
            ShowButton(
              label: 'เพิ่มสินค้า',
              pressFunc: () {
                if (file == null) {
                  MyDialog(context: context).normalDialog(
                    title: 'ยังไม่มีรูปสินค้า',
                    message: 'กรุณาเพิ่มรูปภาพ',
                  );
                } else if ((name?.isEmpty ?? true) ||
                    (price?.isEmpty ?? true) ||
                    (unit?.isEmpty ?? true) ||
                    (stock?.isEmpty ?? true) ||
                    (detail?.isEmpty ?? true)) {
                  MyDialog(context: context).normalDialog(
                      title: 'มีช่องว่าง', message: 'กรุณากรอกทุกช่องครับ');
                } else {
                  processUploadAndInsertData();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processTakePhoto({required ImageSource source}) async {
    Navigator.pop(context);
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    setState(() {
      file = File(result!.path);
    });
  }

  Future<void> processUploadAndInsertData() async {
    String uidLogin = user!.uid;
    String nameFile = '$uidLogin${Random().nextInt(100000)}.jpg';
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('product/$nameFile');
    UploadTask uploadTask = reference.putFile(file!);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) async {
        String urlProduct = value;
        ProductModel productModel = ProductModel(
            detail: detail!,
            name: name!,
            price: int.parse(price!),
            status: 'on',
            stock: int.parse(stock!),
            timeAdd: Timestamp.fromDate(dateTime),
            unit: unit!,
            urlProduct: urlProduct);

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uidLogin)
            .collection('product')
            .doc()
            .set(productModel.toMap())
            .then((value) {
              Navigator.pop(context);
            });
      });
    });
  }
}
