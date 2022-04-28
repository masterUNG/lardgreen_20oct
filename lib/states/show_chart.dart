import 'package:flutter/material.dart';
import 'package:lardgreen/models/sqllite_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/sqllite_helper.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

class ShowChart extends StatefulWidget {
  const ShowChart({Key? key}) : super(key: key);

  @override
  State<ShowChart> createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  var sqlModels = <SQLiteModel>[];
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    readMyChart();
  }

  Future<void> readMyChart() async {
    if (sqlModels.isNotEmpty) {
      sqlModels.clear();
    }

    await SQLiteHelper().readAllDatabase().then((value) {
      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var item in value) {
          SQLiteModel model = item;
          sqlModels.add(model);
        }
      }
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'ตะกร้า',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: load
          ? const ShowProgress()
          : haveData!
              ? newContent()
              : Center(
                  child: ShowText(
                    lable: 'ยังไม่มีสินค้าในตะกร้า',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }

  Widget newContent() => Column(
        children: [
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              ShowTitle(title: 'สินค้าจากร้าน :'),
              ShowText(lable: sqlModels[0].nameSeller),
            ],
          ),
          Divider(
            color: MyConstant.dark,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'สินค้า',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'ราคา',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'จำนวน',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ShowText(
                  lable: 'รวม',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              
            ],
          ),
          Divider(color: MyConstant.dark,),
        ],
      );
}
