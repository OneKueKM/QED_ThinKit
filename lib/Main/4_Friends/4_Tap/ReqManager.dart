import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../4_Widget/FriendList.dart';
import 'ReqSender.dart';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ReqManager extends StatefulWidget {
  const ReqManager({Key? key}) : super(key: key);

  @override
  State<ReqManager> createState() => _ReqManagerState();
}

int value = 0;

class _ReqManagerState extends State<ReqManager> {
  bool isAddFriends = true;

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser; //접속한 아이디의 UID
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(me!.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 150,
        leading: Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Center(
              child: Text(
                '친구 요청',
                // ignore: prefer_const_constructors
                style: TextStyle(
                    fontFamily: 'SFProText',
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 30,
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedToggleSwitch<bool>.size(
                  height: 30,
                  current: isAddFriends,
                  values: const [true, false],
                  iconOpacity: 0.7,
                  animationDuration: const Duration(milliseconds: 300),
                  indicatorSize: const Size(40, double.infinity),
                  borderWidth: 3.0,
                  indicatorColor: Colors.white,
                  borderColor: const Color.fromARGB(255, 239, 239, 239),
                  innerColor: const Color.fromARGB(255, 239, 239, 239),
                  onChanged: (i) {
                    HapticFeedback.mediumImpact();
                    setState(() => isAddFriends = i);
                  },
                  iconBuilder: (value, size) {
                    if (value) {
                      return const Center(
                        heightFactor: 30,
                        child: Text(
                          '검색',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      );
                    } else {
                      return const Center(
                          heightFactor: 30,
                          child: Text('요청',
                              style: TextStyle(
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: userDocRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              var myData = snapshot.data?.data();
              if (isAddFriends) {
                return Expanded(
                  child: ReqSender(
                    friendRequested: myData!['friendRequested'] ?? [],
                    friendRequesting: myData['friendRequesting'] ?? [],
                  ),
                );
              } else {
                return SafeArea(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 20,
                        child: const Text(
                          '받은 요청 (0)',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(255, 99, 99, 99)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      FriendList(
                        friendRefList: myData!['friendRequested'] ?? [],
                        requested: true,
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 30,
                          width: 500,
                          child: const Divider(
                              color: Color.fromARGB(255, 222, 222, 222),
                              thickness: 1)),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 20,
                        child: const Text(
                          '보낸 요청 (2)',
                          style: TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(255, 99, 99, 99)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      FriendList(
                        friendRefList: myData['friendRequesting'] ?? [],
                        requesting: true,
                      ),
                    ]));
              }
            }),
      ]),
    );
  }
}
