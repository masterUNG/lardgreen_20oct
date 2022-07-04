// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/utility/my_constant.dart';

class ShowButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  final double? width;
  final Color? color;

  const ShowButton({
    Key? key,
    required this.label,
    required this.pressFunc,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: width ?? 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: color ?? MyConstant.primary),
        onPressed: pressFunc,
        child: Text(label,style: TextStyle(fontSize: 18),),
      ),
    );
  }
}
