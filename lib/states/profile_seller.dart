// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lardgreen/models/user_model.dart';
import 'package:lardgreen/utility/my_constant.dart';
import 'package:lardgreen/widgets/show_image.dart';
import 'package:lardgreen/widgets/show_text.dart';
import 'package:lardgreen/widgets/show_title.dart';

import '../widgets/show_icon_button.dart';

class ProfileSeller extends StatefulWidget {
  final UserModle userModle;

  const ProfileSeller({
    Key? key,
    required this.userModle,
  }) : super(key: key);

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  UserModle? userModle;
  @override
  void initState() {
    super.initState();
    userModle = widget.userModle;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 32),
            width: 250,
            height: 250,
            child: Stack(
              children: [
                newImage(),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: ShowIconButton(
                    iconData: Icons.add_a_photo,
                    pressFunc: () {},
                  ),
                ),
              ],
            ),
          ),
          newDetail(head: 'ร้าน:', value: userModle!.name),
          newDetail(head: 'ที่อยู่:', value: userModle!.address),
          newDetail(head: 'โทรศัทพ์:', value: userModle!.phone),
        ],
      ),
    );
  }

  Padding newImage() {
    return const Padding(
                padding: EdgeInsets.all(32.0),
                child: ShowImage(
                  path: 'images/shop.png',
                ),
              );
  }

  Row newDetail({required String head, required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ShowText(
            lable: head,
            textStyle: MyConstant().h2Style(),
          ),
        ),
        Expanded(
          flex: 2,
          child: ShowText(
            lable: value,
          ),
        ),
      ],
    );
  }
}
