import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyChats extends StatelessWidget {
  const MyChats({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Start a convo!'),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final currentChatInfo = loadedMessages[index].data();
            final nextChatInfo = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentUserName = currentChatInfo['username'];
            final nextUserName =
                nextChatInfo != null ? nextChatInfo['username'] : null;

            final isNextUserTrue = currentUserName == nextUserName;
            if (isNextUserTrue) {
              return MessageBubble.next(
                message: currentChatInfo['text'],
                isMe: currentChatInfo['userId'] == loggedInUser.uid,
              );
            } else {
              return MessageBubble.first(
                  userImage: currentChatInfo['userImage'],
                  username: currentChatInfo['username'],
                  message: currentChatInfo['text'],
                  isMe: currentChatInfo['userId'] == loggedInUser.uid);
            }
          },
        );
      },
    );
  }
}
