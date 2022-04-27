import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_progress.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userModels = <UserModle>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    readAllSeller();
  }

  Future<void> readAllSeller() async {
    await FirebaseFirestore.instance
        .collection('user')
        .where('typeUser', isEqualTo: 'seller')
        .get()
        .then((value) {
      load = false;
      int i = 1;
      for (var item in value.docs) {
        UserModle userModle = UserModle.fromMap(item.data());
        if (i <= 6) {
          userModels.add(userModle);
        }
        i++;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      return load
          ? const ShowProgress()
          : ListView(
              children: [
                const ShowTitle(title: 'โปรโมชั่น'),
                Container(
                  decoration:
                      BoxDecoration(color: MyConstant.light.withOpacity(0.75)),
                  alignment: Alignment.center,
                  width: Constraints.maxWidth,
                  height: 150,
                  child: ShowText(
                    lable: 'Banner',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
                const ShowTitle(title: 'ร้านค้า :'),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ), //column to show

                  itemBuilder: (BuildContext context, int index) => Card(
                    color: Colors.lime,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: userModels[index].urlAvatar!.isEmpty
                              ? const ShowImage(
                                  path: 'images/shop.png',
                                )
                              : Image.network(
                                  userModels[index].urlAvatar!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        ShowText(lable: userModels[index].name),
                      ],
                    ),
                  ),
                  itemCount: userModels.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            );
    });
  }
}
