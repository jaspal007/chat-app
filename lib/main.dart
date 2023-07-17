import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool loading = true;
  String userImage = '';
  void getUserData(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    userImage = userData.data()!['imageUrl'];
    loading = false;
    return;
  }

  void setContent() {
    print('now here $loading');
    setState(() {
      loading = false;
    });
    print('hogya $loading');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chat App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: AnimatedSplashScreen(
        duration: 50,
        splash: const SplashScreen(),
        nextScreen: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshots.hasData) {
              if (loading) {
                getUserData(snapshots.data!.uid);
                snapshots.data!.reload();
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              } else {
                return ChatScreen(userImage: userImage);
              }
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
