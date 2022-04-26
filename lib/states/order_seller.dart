// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

class OrderSeller extends StatelessWidget {
  final UserModle userModle;

  const OrderSeller({
    Key? key,
    required this.userModle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowTitle(title: 'รายการสั่งซื้อ');
  }
}
