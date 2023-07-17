import 'dart:io';
import 'package:chat_app/widgets/chats.dart';
import 'package:chat_app/widgets/new_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userImage,
  });
  final String userImage;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer,
        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              child: CircleAvatar(
                foregroundImage: NetworkImage(widget.userImage),
              ),
              onTap: () {
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
            ),
          ),
        ],
        centerTitle: true,
        title: const Text('C H A T S'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Logged In! ${FirebaseAuth.instance.currentUser!.email}'),
            const Expanded(child: MyChats()),
            const NewChat(),
          ],
        ),
      ),
    );
  }
}
