import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/flutter_widgets/text_form_field.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({
    super.key,
    required this.function,
  });
  final Function function;
  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final form = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  String _enteredEmail = '';
  final TextEditingController password = TextEditingController();
  String _enteredPassword = '';

  void submitForm() async {
    final isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successful Login'),
          ),
        );
        print(userCredential);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormFieldInput(
              textEditingController: email,
              textInputType: TextInputType.emailAddress,
              label: 'Email',
              isValid: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
              onSave: (value) => _enteredEmail = value!,
            ),
            TextFormFieldInput(
              textEditingController: password,
              label: 'Password',
              obscure: true,
              isValid: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Your password is too short';
                }
                return null;
              },
              onSave: (value) => _enteredPassword = value!,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('New user?'),
                TextButton(
                  onPressed: () {
                    widget.function();
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
