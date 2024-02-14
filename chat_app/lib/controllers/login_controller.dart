import 'dart:convert';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModel {
  
  String username;
  String userId;
  UserModel({required this.username, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": username,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      username: json["name"],
    );
  }
}

class LoginController extends GetxController {
  List<UserModel> users = [];
bool isSignedIn = false;
  RxBool isLoading = false.obs;
String? websocketUrl;
  Future<void> saveDataToShared(List<UserModel> value) async {
    List userModelToJson = value
        .map<Map<String, dynamic>>((answersModel) => answersModel.toJson())
        .toList();
    print("Saved data to SharedPreferences: $userModelToJson");
    sharedPreferences?.setString("users", json.encode(userModelToJson));
  }

  Future<List<UserModel>?> readUserData(String key) async {
    final String? jsonString = sharedPreferences?.getString(key);

    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<UserModel> jsonToUserModel = decodeJsonData
          .map<UserModel>((jsonPostModel) => UserModel.fromJson(jsonPostModel))
          .toList();

      return jsonToUserModel;
    } else {
      print("empty");
    }
  }

  // Future<void> saveDataToShared() async {
  //   sharedPreferences?.setStringList(
  //       "username", users.map((e) => e.username).toList());
  //   sharedPreferences?.setStringList(
  //       "userId", users.map((e) => e.userId).toList());
  //   print("=============shared is $sharedPreferences");
  // }

  Future<List<String>?> getDataFromShared() async {
    return sharedPreferences?.getStringList("username");
  }

  Future<void> login(context) async {
    isLoading.value = true;

    // Simulate login action with a delay
    await Future.delayed(const Duration(milliseconds: 1300));

    // Perform actual login logic here

    isLoading.value = false;

    Navigator.of(context).push(_createRoute());
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomeNavBar(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
