import 'package:flutter/material.dart';
import 'package:get/get.dart';


customSnackbar(String title,String message) {
  return Get.snackbar(
    title,
   message,
    backgroundColor: Colors.black.withOpacity(0.6),
    colorText: Colors.white,
    animationDuration: Duration(milliseconds: 600),duration: Duration(milliseconds: 1700),
    dismissDirection: DismissDirection.vertical,snackPosition: SnackPosition.TOP,
    
  );
}