import 'package:chat_app/widgets/flutter_widgets/text_form_field.dart';
import 'package:chat_app/widgets/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String _enteredEmail = '';
  String _enteredPassword = '';

  void submit() async {
    final _isValid = formKey.currentState!.validate();

    if (_isValid) {
      formKey.currentState!.save();
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saving user credentials'),
          ),
        );
        print(userCredential);

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
            const UserImagePicker(),
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
            ElevatedButton(
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
