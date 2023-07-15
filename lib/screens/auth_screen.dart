import 'package:chat_app/screens/auth_screen_login.dart';
import 'package:chat_app/screens/auth_screen_signup.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  final key = GlobalKey();
  int tab = 0;

  void onClick() {
    {
      setState(() {
        tabController.animateTo(
          tab = (tab + 1) % 2,
        );
        tabController.index = tab;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      super.initState();
      tabController.addListener(() {
        setState(() {
          tab = tabController.index;
        });
      });
    }

    @override
    void dispose() {
      tabController.dispose();
      super.dispose();
    }

    return DefaultTabController(
      key: key,
      initialIndex: tab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: (tab == 0) ? 150 : 50,
                  child: Image.asset('assets/images/chat.jpeg'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.maxFinite,
                        child: TabBar(
                          controller: tabController,
                          onTap: (value) {
                            setState(() {
                              tab = value;
                            });
                          },
                          tabs: [
                            Text(
                              'Login',
                              style: const TextStyle().copyWith(fontSize: 20),
                            ),
                            Text(
                              'SignUp',
                              style: const TextStyle().copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          top: 10,
                        ),
                        height: tab == 0 ? 300 : 400,
                        width: double.maxFinite,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            UserLogin(function: onClick,),
                            UserSignUp(function: onClick,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
