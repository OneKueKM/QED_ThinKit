import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qed_app_thinkit/Main/0_Intro/LoginScreens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../BasicWidgets/BotNaviBar.dart';
import 'dart:math';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSpinning = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pwAgainController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: _isSpinning,
      opacity: 0.5,
      progressIndicator: const CircularProgressIndicator(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome To ThinKit!",
                    style: TextStyle(fontSize: 30)),
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: _telephoneController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Telephone Number',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                hintText: 'UserName',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: _pwAgainController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password Again',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                } else if (_pwAgainController.text !=
                                    _passwordController.text) {
                                  return '비밀번호가 다릅니다.';
                                }
                                return null;
                              }),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      _isSpinning = true;
                                      final newUser = await _firebaseAuth
                                          .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      var defaultURL = await FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('profile')
                                          .child('default.jpeg')
                                          .getDownloadURL();

                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(newUser.user!.uid)
                                          .set(
                                        {
                                          'userID': '',
                                          'userName': _usernameController.text,
                                          'email': _emailController.text,
                                          'userExplain': '',
                                          'userProfile': defaultURL,
                                          //Firebase Storage에 기본 프로필을 저장한 후 설정 완료
                                          'telephoneNum':
                                              _telephoneController.text,
                                          'teams': <String>[],
                                          'exposeTelnum' : true,
                                          'connected' : 0
                                        },
                                      );

                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(newUser.user!.uid)
                                          .collection('Memos')
                                          .add({
                                        'title': '나의 메모',
                                        'content': '나의 내용',
                                        'colorNum': Random().nextInt(10),
                                        'dateEdited': DateTime.now(),
                                      });

                                      if (newUser.user != null) {
                                        _isSpinning = false;
                                        Get.to(MyPage());
                                      }
                                    } catch (e) {
                                      Get.snackbar('Error', e.toString());
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        //버튼을 둥글게 처리
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 120, vertical: 8)),
                                child: const Text('Sign Up'),
                              )),
                        ],
                      ),
                    )),
                GestureDetector(
                    onTap: () => Get.offAll(LogIn()),
                    child: const Text("로그인 패이지로 돌아가기"))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
