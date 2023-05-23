import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../BasicWidgets/BotNaviBar.dart';
import 'SignUp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogIn extends StatelessWidget {
  LogIn({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSpinning = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
              children: [
                Container(
                  width: 400,
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login.png'))),
                ),
                const SizedBox(height: 150),
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          TextFormField(
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              showCursor: false,
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5, 0, 10),
                                hintStyle: TextStyle(
                                  fontFamily: 'SFProDisplay',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                hintText: 'Email',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return '이메일 주소를 입력해주세요';
                                }
                                return null;
                              }),
                          const SizedBox(height: 10),
                          TextFormField(
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              showCursor: false,
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5, 0, 10),
                                hintStyle: TextStyle(
                                  fontFamily: 'SFProDisplay',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                hintText: 'Password',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호를 입력해주세요';
                                }
                                return null;
                              }), //비밀번호 입력란
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      _isSpinning = true;
                                      final newUser = await _firebaseAuth
                                          .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

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
                                    backgroundColor:
                                        const Color.fromARGB(255, 61, 133, 192),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 3)),
                                child: const Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () => Get.to(SignUp()),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        child: const Text(
                          '비밀번호찾기',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () => Get.to(SignUp()),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
