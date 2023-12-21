import 'package:chat_app/components/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title: "Contacts",body: Text("Contacts"),);
  }
}