import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chats'),
      ),
      body: Center(
        child: Text('Logged In! ${FirebaseAuth.instance.currentUser!.email}'),
      ),
    );
  }
}
