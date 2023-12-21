import 'package:chat_app/components/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title: "Profile",body: Container(height: 100,width: 100,
      color: Colors.blue),);
  }
}