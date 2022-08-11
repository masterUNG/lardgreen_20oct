// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lardgreen/models/order_product_model.dart';
import 'package:lardgreen/models/slip_model.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/utility/my_firebase.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_icon_button.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_text.dart';

class UploadSlip extends StatefulWidget {
  final String docIdOrder;
  final OrderProductModel orderProductModel;

  const UploadSlip({
    Key? key,
    required this.docIdOrder,
    required this.orderProductModel,
  }) : super(key: key);

  @override
  State<UploadSlip> createState() => _UploadSlipState();
}

class _UploadSlipState extends State<UploadSlip> {
  String? docIdOrder;
  File? file;

  @override
  void initState() {
    super.initState();
    docIdOrder = widget.docIdOrder;
  }

  Future<void> processTakePhoto({required ImageSource imageSource}) async {
    var result = await ImagePicker().pickImage(
      source: imageSource,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (result != null) {
      setState(() {
        file = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          lable: 'ส่งสลิปโอนเงิน',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 250,
              height: 250,
              child: file == null
                  ? const ShowImage(
                      path: 'images/product.png',
                    )
                  : Image.file(file!),
            ),
            SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () {
                      processTakePhoto(imageSource: ImageSource.camera);
                    },
                  ),
                  ShowButton(
                    label: 'ส่งสลิป',
                    pressFunc: () {
                      if (file == null) {
                        MyDialog(context: context).normalDialog(
                            title: 'ยังไม่มี หลักฐานโอนเงิน',
                            message:
                                'กรุณา ถ่ายภาพ หรือ เลือกภาพ หลักฐานโอนเงิน');
                      } else {
                        processUploadSlip();
                      }
                    },
                    width: 120,
                  ),
                  ShowIconButton(
                    iconData: Icons.add_photo_alternate,
                    pressFunc: () {
                      processTakePhoto(imageSource: ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processUploadSlip() async {
    String nameSlip = 'slip ${Random().nextInt(1000000)}.jpg';
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('/slip/$nameSlip');
    UploadTask uploadTask = reference.putFile(file!);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) async {
        String urlSlip = value;
        print('urlSlip ==> $urlSlip');

        SlipModel slipModel = SlipModel(urlSlip: urlSlip);
        await FirebaseFirestore.instance
            .collection('order')
            .doc(docIdOrder)
            .collection('slip')
            .doc()
            .set(slipModel.toMap())
            .then((value) async {
          Map<String, dynamic> map = {};
          map['status'] = 'paymented';
          await FirebaseFirestore.instance
              .collection('order')
              .doc(docIdOrder)
              .update(map)
              .then((value) async {
            UserModle userModle = await MyFirebase()
                .processFindUserModel(uid: widget.orderProductModel.uidSeller);

            MyFirebase().processSentNotification(
                title: 'จ่า่ยเงินแล้ว',
                body: 'ลูกค้าจ่ายเงินแล้วครับ',
                token: userModle.token);

            Navigator.pop(context);
          });
        });
      });
    });
  }
}
