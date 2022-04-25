// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/widgets/show_text.dart';

import '../utility/my_constant.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  
  const ShowTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: ShowText(
        lable: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}
