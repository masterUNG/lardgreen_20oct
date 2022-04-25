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

  Future<void> normalDialog(
      {required String title, required String message}) async {
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
        actions: [ShowTextButton(label: 'OK', pressFunc: (){
          Navigator.pop(context);
        }),],
      ),
    );
  }
}
