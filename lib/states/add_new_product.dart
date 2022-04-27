import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lardgreen/utility/my_constant.dart';
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
  String? showDateTime;

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
      body: ListView(
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
                      child: const ShowImage(
                        path: 'images/product.png',
                      ),
                    ),
                    Positioned(bottom: 0,right: 0,
                      child: ShowIconButton(
                        iconData: Icons.add_a_photo,
                        pressFunc: () {},
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
                changeFunc: (String string) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowForm(
                label: 'ราคา',
                iconData: Icons.price_change_outlined,
                changeFunc: (String string) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowForm(
                label: 'หน่วยสินค้า',
                iconData: Icons.ac_unit,
                changeFunc: (String string) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowForm(
                label: 'สต็อก',
                iconData: Icons.abc_sharp,
                changeFunc: (String string) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowForm(
                label: 'รายละเอียด',
                iconData: Icons.details,
                changeFunc: (String string) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
