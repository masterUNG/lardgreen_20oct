// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function(String) changeFunc;
  final TextInputType? textInputType;
  final bool? obscue; //encryption
  final double? width;
  final int? maxLength;
  final TextEditingController? textEditingController;

  const ShowForm({
    Key? key,
    required this.label,
    required this.iconData,
    required this.changeFunc,
    this.textInputType,
    this.obscue,
    this.width,
    this.maxLength,
    this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: width ?? 250,
      height: maxLength == null ? 40 : 50,
      child: TextFormField(controller: textEditingController,
        maxLength: maxLength,
        obscureText: obscue ?? false,
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: changeFunc,
        decoration: InputDecoration(
          suffixIcon: Icon(
            iconData,
            color: MyConstant.dark,
          ),
          label: ShowText(lable: label),
          contentPadding: EdgeInsets.symmetric(vertical: maxLength == null ? 4 : 8, horizontal: 16),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyConstant.light)),
        ),
      ),
    );
  }
}
