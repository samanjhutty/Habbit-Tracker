import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String user = 'Guest';
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Greetings $user!',
          style: const TextStyle(fontWeight: FontWeight.w600),
        )),
        body: const Center(
          child: Text('User Profile'),
        ),
      ),
    );
  }
}
