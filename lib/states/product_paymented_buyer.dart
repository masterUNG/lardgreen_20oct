import 'package:flutter/material.dart';
import 'package:lardgreen/widgets/show_text.dart';

class ProductPaymentedBuyer extends StatelessWidget {
  const ProductPaymentedBuyer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowText(lable: 'This is paymented'),
    );
  }
}