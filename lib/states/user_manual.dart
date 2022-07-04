import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';

class UserManual extends StatefulWidget {
  const UserManual({Key? key}) : super(key: key);

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  String textManual =
      'เลือก เมนูสมาชิก จะไปยัง หน้าเข้าใช้งาน (Login) หรือสมัครสมาชิกใหม่ กรอกข้อมูลให้ครบถ้วน สามารถเลือกผู้ใช้งานได้ 2 แบบ คือ ผู้ซื้อหรือผู้ขาย หากเป็นผู้ขายเมื่อลงทะเบียนใช้เสร็จจะต้องรอการตรวจสอบจากผู้ดูแลระบบหลาดกรีนปั้นสุขก่อนว่าผ่านมาตรฐานเกษตรอินทรีย์หรือไม่';
  String textBuy =
      'ผู้ซื้อ เลือกซื้อสินค้าและจ่ายเงินให้เสร็จทีละร้าน เมื่อเลือกสินค้าเสร็จสามารถคลิกที่ตะกร้าเพื่อดูสินค้า และสามารถลบสินค้าได้ หากพอใจให้ยืนยันและรอร้านยืนยันการสั่งซื้อก่อนจะจ่ายเงิน';
  String textPayment =
      'เมื่อร้านยืนยันสินค้า ผู้ซื้อจะได้รับการแจ้งเตือนและสามารถเข้าดูในเมนูรายการสินค้ายืนยัน จากเลือกจ่ายเงิน โดยการโอนเงินเข้าบัญชีร้านค้าและอัพโหลดสลิป';

  String textRecive = 'เมื่อร้านได้รับการแจ้งเตือนการจ่ายเงินสินค้า ร้านจะส่งของตามจุดรับสินค้า เมื่อผู้ซื้อได้รับสินค้าเสร็จ ให้เข้าเมนูรับสินค้า และกดปุ่มรับสินค้า หากไม่ได้รับสินค้าผู้ซื้อสามารถโทรหาร้านค้าได้ ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          lable: 'คู่มือการใช้งาน',
          textStyle: MyConstant().h1Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: Container(
        margin: EdgeInsets.all(18),
        child: Column(
          children: [
            ShowText(
              lable: 'การเข้าใช้งาน',
              textStyle: MyConstant().h2Style(),
            ),
            ShowText(
              lable: textManual,
              textStyle: MyConstant().h4Style(),
            ),
            ShowText(
              lable: 'การเลือกซื้อสินค้า',
              textStyle: MyConstant().h2Style(),
            ),
            ShowText(
              lable: textBuy,
              textStyle: MyConstant().h4Style(),
            ),
            ShowText(
              lable: 'การจ่ายเงิน',
              textStyle: MyConstant().h2Style(),
            ),
            ShowText(
              lable: textPayment,
              textStyle: MyConstant().h4Style(),
            ),
            ShowText(
              lable: 'การรับสินค้า',
              textStyle: MyConstant().h2Style(),
            ),
            ShowText(
              lable: textRecive,
              textStyle: MyConstant().h4Style(),
            ),
          ],
        ),
      ),
    );
  }
}
