import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'logout',
            onPressed: () {
              if (Platform.isIOS) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Logout!'),
                    content: const Text('This action can\'t be undone'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout!'),
                  content: const Text('This action can\'t be undone'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
        centerTitle: true,
        title: const Text('Chats'),
      ),
      body: Center(
        child: Text('Logged In! ${FirebaseAuth.instance.currentUser!.email}'),
      ),
    );
  }
}
