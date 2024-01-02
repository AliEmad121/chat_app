import 'package:app_minimizer/app_minimizer.dart';
import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final SignedUserController signedUserController =
      Get.put(SignedUserController());
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        FlutterAppMinimizer.minimize();
      },
      child: CustomScaffold(
        leading: IconButton(
            onPressed: () {
              setState(() {
                navigationController.selectedIndex.value = 0;
                FlutterAppMinimizer.minimize();
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.black,
            )),
        title: "Home",
        body: ListView.builder(
            itemCount: loginController.users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: AssetImage("assets/images/avatar.png"),
                          fit: BoxFit.fill)),
                ),
                title: Text(loginController.users[index],
                    style: Theme.of(context).textTheme.headlineMedium),
                subtitle: Row(
                  children: [
                    Text("Online"),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.green,
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
