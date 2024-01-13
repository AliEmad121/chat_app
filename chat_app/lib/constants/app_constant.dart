import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static final navigationKey = GlobalKey<NavigatorState>();


static final RegExp userNameRegex = RegExp(r'\b\w{4}\b');

static final RegExp passwordRegex = RegExp(r'\b[A-Za-z0-9]{6}\b'); /// numbers and chars


// static final RegExp passwordRegex = RegExp(r'\b\d{6}\b');///  only numbers 




  







}
