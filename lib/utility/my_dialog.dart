// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_text_button.dart';

import '../widgets/show_image.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDialog({
    required String title,
    required String message,
    Function()? presFunc,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(),
          title: ShowText(
            lable: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(lable: message),
        ),
        actions: [
          ShowTextButton(
            label: 'OK',
            pressFunc: presFunc ??
                () {
                  Navigator.pop(context);
                },
          ),
        ],
      ),
    );
  }

  Future<void> actionDialog({
    required String title,
    required String message,
    required String label1,
    required String label2,
    required Function() presFunc1,
    required Function() presFunc2,
    bool? cancleButton,
    Widget? contentWidget,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(),
          title: ShowText(
            lable: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(lable: message),
        ),
        content: contentWidget ?? const SizedBox(),
        actions: [
          ShowTextButton(
            label: label1,
            pressFunc: presFunc1,
          ),
          ShowTextButton(
            label: label2,
            pressFunc: presFunc2,
          ),
          cancleButton == null
              ? const SizedBox()
              : cancleButton
                  ? ShowTextButton(
                      label: 'ปิดหน้าต่าง',
                      pressFunc: () {
                        Navigator.pop(context);
                      })
                  : const SizedBox(),
        ],
      ),
    );
  }
}
