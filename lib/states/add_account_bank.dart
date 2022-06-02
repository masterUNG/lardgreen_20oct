// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lardgreen/models/bank_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/utility/my_dialog.dart';
import 'package:lardgreen/widgets/show_button.dart';
import 'package:lardgreen/widgets/show_form.dart';
import 'package:lardgreen/widgets/show_text.dart';

class AddAccountBank extends StatefulWidget {
  final String docId;
  const AddAccountBank({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<AddAccountBank> createState() => _AddAccountBankState();
}

class _AddAccountBankState extends State<AddAccountBank> {
  var nameBanks = [];
  var svgBanks = [];
  var indexs = <int>[0, 1, 2, 3, 4];

  String? nameBank, svgBank, nameAccountBank, accountBank;
  int? indexxBank;

  @override
  void initState() {
    super.initState();
    nameBanks.addAll(MyConstant.nameBank);
    svgBanks.addAll(MyConstant.svgBanks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShowText(
          lable: 'เพิ่มบัญชี ธนาคาร',
          textStyle: MyConstant().h2Style(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Center(
          child: Column(
            children: [
              newDropDownNameBank(),
              ShowForm(
                  label: 'ชือบัญชีธนาคาร',
                  iconData: Icons.fingerprint,
                  changeFunc: (String string) {
                    nameAccountBank = string.trim();
                  }),
              ShowForm(
                maxLength: 10,
                textInputType: TextInputType.number,
                label: 'หมายเลขบัญชีธนาคาร',
                iconData: Icons.account_balance,
                changeFunc: (String string) {
                  accountBank = string.trim();
                },
              ),
              ShowButton(
                label: 'บันทึกบัญชี',
                pressFunc: () {
                  if (indexxBank == null) {
                    MyDialog(context: context).normalDialog(
                        title: 'ชื่อธนาคาร ?', message: 'โปรดเลือกธนาคาร');
                  } else if ((nameAccountBank?.isEmpty ?? true) ||
                      (accountBank?.isEmpty ?? true)) {
                    MyDialog(context: context).normalDialog(
                        title: 'มีช่องว่าง', message: 'กรุณากรอกให้ครบทุกช่อง');
                  } else if (accountBank!.length != 10) {
                    MyDialog(context: context).normalDialog(
                        title: 'เลขบัญชีผิด', message: 'เลขบัญชีไม่ครบ');
                  } else {
                    processSaveBank();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<dynamic> newDropDownNameBank() {
    return DropdownButton<dynamic>(
      hint: const ShowText(lable: 'โปรดเลือกธนาคาร'),
      value: indexxBank,
      items: indexs
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: ShowText(
                lable: nameBanks[e],
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          indexxBank = value;
        });
      },
    );
  }

  Future<void> processSaveBank() async {
    BankModel bankModel = BankModel(
        nameBank: nameBanks[indexxBank!],
        nameAccountBank: nameAccountBank!,
        accountBank: accountBank!);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docId)
        .collection('bank')
        .doc()
        .set(bankModel.toMap())
        .then((value) {
      Navigator.pop(context);
    });
  }
}
