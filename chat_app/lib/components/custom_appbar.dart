import 'package:chat_app/constants/app_colors.dart';

import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height = 50;
  bool? centerTitle;

  CustomAppBar({
    this.title,
    this.actions,
    this.leading,
    this.centerTitle ,
  });
 final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // your customization here
      title: Text(
        '$title',
        style: TextStyle( color: AppColors.black,fontSize: 20),
      ),
      leading: leading??null,
      centerTitle: centerTitle?? false,
      backgroundColor: AppColors.grey.withOpacity(0.2),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}


