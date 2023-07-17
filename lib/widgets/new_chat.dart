import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final TextEditingController chatText = TextEditingController();
  String _enteredText = '';
  final scroll = ScrollController();
  double textFieldWidth = 240;

  void onSubmit() async {
    if (chatText.text.trim().isEmpty) {
      chatText.clear();
      return;
    }
    _enteredText = chatText.text.trim();
    chatText.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chats').add({
      'text': _enteredText,
      'time': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatText.dispose();
  }

  @override
  void initState() {
    super.initState();
    chatText.addListener(() {
      setState(() {
        if (chatText.text.isNotEmpty) {
          textFieldWidth = 280;
        } else {
          textFieldWidth = 240;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 100),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 0,
              right: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 100),
                  width: textFieldWidth,
                  child: TextField(
                    scrollController: scroll,
                    controller: chatText,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      hintText: 'Say hi…',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                if (chatText.text.isEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.background,
                          iconSize: 20,
                          padding: const EdgeInsets.only(
                            bottom: 0.5,
                            left: 0.5,
                          ),
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                (chatText.text.isEmpty)
                    ? CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.background,
                          padding: const EdgeInsets.only(
                            bottom: 1,
                            left: 0.5,
                          ),
                          visualDensity: VisualDensity.compact,
                          onPressed: () {},
                          icon: const Icon(Icons.mic),
                        ),
                      )
                    : CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.background,
                          padding: const EdgeInsets.only(
                            bottom: 1,
                            left: 3,
                          ),
                          onPressed: onSubmit,
                          icon: const Icon(
                            Icons.send,
                            size: 20,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
