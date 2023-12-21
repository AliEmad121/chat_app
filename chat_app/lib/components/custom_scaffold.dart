import 'package:chat_app/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class CustomScaffold extends StatefulWidget {
  CustomScaffold({super.key, this.title, required this.body,this.resizeToAvoidBottomInset,this.centerTitle, this.leading, this.actions});
  final Widget body;
  final String? title;
 bool? resizeToAvoidBottomInset;
 bool ?centerTitle;
  final Widget? leading;
   final List<Widget>? actions;
  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset?? false,
      appBar: CustomAppBar(title:widget.title,centerTitle: widget.centerTitle,leading:widget.leading, actions: widget.actions,),
      body: widget.body,
      
    ));
  }
}
