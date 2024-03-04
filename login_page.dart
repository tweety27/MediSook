/// login page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        User? user = authService.currentUser();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Medi',
              style: TextStyle(color: Colors.black, fontSize: 28),
            ),
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.chevron_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    user == null ? "Login" : "${user.email}님 안녕하세요 👋",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "e-mail"),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "password"),
                ),
                SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: Text("sign in", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 로그인
                    authService.signIn(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 로그인 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("로그인 성공"),
                        ));

                        // HomePage로 이동
                        Navigator.pop(context);
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),

                /// 회원가입 버튼
                TextButton(
                  child: Text("sign up",
                      style: TextStyle(fontSize: 15, color: Colors.indigo)),
                  onPressed: () {
                    // 회원가입
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 회원가입 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),
                // 로그아웃 버튼
                Padding(
                  padding: const EdgeInsets.only(
                    top: 370,
                  ),
                  child: TextButton(
                    onPressed: () {
                      // 로그아웃
                      context.read<AuthService>().signOut();
                    },
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
