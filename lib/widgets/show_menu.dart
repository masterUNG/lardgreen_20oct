// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';

class ShowMenu extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String? subTitle;
  final Function() tapFunc;

  const ShowMenu({
    Key? key,
    required this.title,
    required this.iconData,
    this.subTitle,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: tapFunc,
      leading: Icon(iconData,color: MyConstant.dark,),
      title: ShowText(lable: title,textStyle: MyConstant().h2Style(),),
      subtitle: ShowText(lable: subTitle?? ''),
    );
  }
}
