import 'package:chat_app/constants/app_routes.dart';

import 'package:get/get.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> signup(context) async {
    isLoading.value = true;

    // Simulate login action with a delay
    await Future.delayed(Duration(milliseconds: 500));

    // Perform actual login logic here

    isLoading.value = false;

    Get.toNamed(AppRoutes.loginPage);
  }
}
