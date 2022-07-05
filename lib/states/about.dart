import 'package:flutter/material.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_text.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String textAbout =
      'แอปพลิเคชันหลาดกรีน Lard Green เป็นงานวิจัยที่ได้ทุนสนับสนุนจาก มหาวิทยาลัยเทคโนโลยีราชมงคลศรีวิชัย วิทยาลัยรัตภูมิ วัตถุประสงค์เพื่อต้องการเป็นแอปพลิเคชันซื้อขายสินค้าเกษตรอินทรีย์ที่มีผู้ขายที่ได้ผ่านการรับรองจากหลาดกรีนเพื่อเพิ่มความมั่นใจกับผู้ซื้อ และเพื่อเพิ่มรายได้ให้กับสมาชิกหลาดกรีน';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          lable: 'เกี่ยวกับแอปพลิเคชัน',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: Container(
        margin: EdgeInsets.all(18),
        child: Column(
          children: [
            ShowText(lable: textAbout),
            // ShowText(
            //   lable: 'ทีมผู้วิจัย',
            //   textStyle: MyConstant().h2Style(),
            // ),ShowText(
            //   lable: 'ผ',
            //   textStyle: MyConstant().h4Style(),
            // )
          ],
        ),
      ),
    );
  }
}
