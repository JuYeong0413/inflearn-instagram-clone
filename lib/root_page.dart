import 'package:flutter/material.dart';
import 'package:instagram_clone/login_page.dart';
import 'package:instagram_clone/tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) { // snapshot은 firebase user 정보가 들어온다
        if (snapshot.hasData) { // 로그인 성공
          return TabPage(snapshot.data);
        } else {
          return LoginPage();
        }
      },
    );
  }
}
