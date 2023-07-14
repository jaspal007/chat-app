import 'package:chat_app/widgets/flutter_widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
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
        if (isLogin) {
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
          print(userCredential);
        } else {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
          print(userCredential);
        }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "CHAT APP",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.jpeg'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: form,
                    child: Column(
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
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(isLogin ? 'Sign Up' : 'Log In'),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            isLogin ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
