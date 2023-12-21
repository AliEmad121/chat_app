import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/components/custom_snackbar.dart';
import 'package:chat_app/components/custom_text_form.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      centerTitle: true,
      title: "Login Page",
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/chat_logo.png"),
                  SizedBox(height: 30),
                  CustomTextField(
                      textInputAction: TextInputAction.next,
                      labelText: "User Name",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailAddressController),
                  SizedBox(height: 10),
                  CustomTextField(
                      textInputAction: TextInputAction.next,
                      labelText: "Password",
                      keyboardType: TextInputType.text,
                      controller: passwordController),
                  SizedBox(height: 30),
                  Container(
                    width: Get.width,
                    height: Get.height * 0.07,
                    child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.blue),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      onPressed: () {

Get.toNamed(AppRoutes.homePage);

                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: AppColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
