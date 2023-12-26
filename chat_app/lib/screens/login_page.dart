import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/components/custom_snackbar.dart';
import 'package:chat_app/components/custom_text_form.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_constant.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailAddressController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  final SignedUserController signedUserController =
      Get.put(SignedUserController());
  Duration duration = Duration(milliseconds: 1500);
  bool isObscure = true;
  bool isUserNameValid = false;
  bool isPasswordValid = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
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
                    controller: emailAddressController,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please, Enter User Name'
                          : AppConstants.userNameRegex.hasMatch(value)
                              ? null
                              : 'Invalid User Name';
                    },
                    onChanged: (value) {
                      _formKey.currentState?.validate();

                      setState(() {
                        isUserNameValid =
                            AppConstants.userNameRegex.hasMatch(value);
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    textInputAction: TextInputAction.next,
                    labelText: "Password",
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please, Enter Password'
                          : AppConstants.passwordRegex.hasMatch(value)
                              ? null
                              : 'Invalid Password';
                    },
                    obscureText: isObscure,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            const Size(48, 48),
                          ),
                        ),
                        icon: Icon(
                          isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: Get.width,
                    height: Get.height * 0.07,
                    child: Obx(() => ElevatedButton(
                        style: ButtonStyle(
                            animationDuration: Durations.extralong4,
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.blue),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                        onPressed: () {
                          if (emailAddressController.text == "sara" ||
                              emailAddressController.text == "admin") {
                            if (passwordController.text == "1234") {
                              loginController.login(context);

                              signedUserController
                                  .signIn(emailAddressController.text);
                              print(signedUserController.username);
                            } else {
                              Get.snackbar(
                                colorText: AppColors.white,
                                "Error",
                                "Check User Name And Password",
                                backgroundColor:
                                    AppColors.black.withOpacity(0.8),
                                dismissDirection: DismissDirection.up,
                              );
                            }
                          } else {
                            Get.snackbar(
                              colorText: AppColors.white,
                              "Error",
                              "Check User Name And Password",
                              backgroundColor: AppColors.black.withOpacity(0.8),
                              dismissDirection: DismissDirection.up,
                            );
                          }
                        },
                        child: loginController.isLoading.value
                            ? CircularProgressIndicator(
                                backgroundColor: AppColors.white,
                                color: AppColors.grey.withOpacity(0.6),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 18),
                              ))),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
