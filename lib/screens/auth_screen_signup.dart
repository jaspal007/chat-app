// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:chat_app/widgets/flutter_widgets/text_form_field.dart';
import 'package:chat_app/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({
    super.key,
    required this.function,
  });
  final Function function;
  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUsername = '';
  String _enteredName = '';
  File? pickedImage;
  bool isAuthenticating = false;
  bool flag = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() async {
      await FirebaseFirestore.instance
          .collection('users')
          .where("username", isEqualTo: usernameController.text.trim())
          .get()
          .then((snapShots) {
        if (snapShots.size > 0) {
          flag = true;
        } else {
          flag = false;
        }
      });
    });
  }

  void submit() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      if (pickedImage == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please Select an image for the account'),
          ),
        );
        return;
      }
      formKey.currentState!.save();
      try {
        setState(() {
          isAuthenticating = true;
        });
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saving user credentials'),
          ),
        );

        final userProfile = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('pfp')
            .child('${userCredential.user!.uid}.jpg');

        await userProfile.putFile(pickedImage!);

        final imageUrl = await userProfile.getDownloadURL();
        print(imageUrl);

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _enteredName,
          'username': _enteredUsername,
          'email': _enteredEmail,
          'imageUrl': imageUrl,
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } on FirebaseAuthException catch (error) {
        SnackBar snackBar = SnackBar(
          content: Text(error.message ?? 'Authentication Failed'),
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserImagePicker(
              onImagePicked: (image) => pickedImage = image,
            ),
            TextFormFieldInput(
              textEditingController: nameController,
              label: 'Name',
              isValid: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter name!';
                }
                return null;
              },
              onSave: (value) => _enteredName = value!,
            ),
            TextFormFieldInput(
              textEditingController: emailController,
              label: 'Email',
              isValid: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Email is not correct format';
                }
                return null;
              },
              onSave: (value) => _enteredEmail = value!,
            ),
            TextFormFieldInput(
              textEditingController: usernameController,
              label: 'Username',
              isValid: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a valid username';
                } else if (flag) {
                  return 'Choose another username';
                }
                return null;
              },
              onSave: (value) => _enteredUsername = value!,
            ),
            TextFormFieldInput(
              textEditingController: passwordController,
              label: 'Password',
              obscure: true,
              isValid: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password too short';
                }
                return null;
              },
              onSave: (value) => _enteredPassword = value!,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Existing User?'),
                TextButton(
                  child: const Text('Login'),
                  onPressed: () {
                    widget.function();
                  },
                ),
              ],
            ),
            isAuthenticating
                ? const CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: submit,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
