import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/components/custom_text_form.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_constant.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController UserNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final SignupController signupController = Get.put(SignupController());

  Duration duration = Duration(milliseconds: 1500);
  bool isObscure = true;
  bool isUserNameValid = false;
  bool isPasswordValid = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: true,
      centerTitle: true,
      title: "SignUp Page",
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
                    controller: UserNameController,
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
                  SizedBox(height: 10),
                  CustomTextField(
                    textInputAction: TextInputAction.next,
                    labelText: "Confirm Password",
                    keyboardType: TextInputType.text,
                    controller: confirmPasswordController,
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
                          if (UserNameController.text.isNotEmpty &&
                              passwordController.text ==
                                  confirmPasswordController.text) {
                            box.write('username', "${UserNameController.text}");
                            box.write('password', "${passwordController.text}");
                            print(box.read('username'));
                            print(box.read('password'));

                            Get.snackbar(
                              colorText: AppColors.white,
                              "Success",
                              "User Created Successfully",
                              backgroundColor: AppColors.black.withOpacity(0.8),
                              dismissDirection: DismissDirection.up,
                            );
                            signupController.signup(context);
                          } else {
                            Get.snackbar(
                              colorText: AppColors.white,
                              "Error",
                              "Check Your Information",
                              backgroundColor: AppColors.black.withOpacity(0.8),
                              dismissDirection: DismissDirection.up,
                            );
                          }
                        },
                        child: signupController.isLoading.value
                            ? CircularProgressIndicator(
                                backgroundColor: AppColors.white,
                                color: AppColors.grey.withOpacity(0.6),
                              )
                            : Text(
                                'SignUp',
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 18),
                              ))),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.loginPage);
                        },
                        child: Text('Login'),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
