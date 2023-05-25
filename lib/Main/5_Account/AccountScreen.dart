import 'package:flutter/material.dart';

import 'package:qed_app_thinkit/Main/5_Account/5_Widget/ProfileCard.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Widget/ActionRow.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Tap/ProfileTap.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Widget/AsKakaoAds.dart';
import 'package:qed_app_thinkit/Main/5_Account/5_Widget/Explains.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _MyAppState();
}

class _MyAppState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(me!.uid);

    return StreamBuilder(
        stream: userDoc.snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(canvasColor: Colors.transparent),
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leadingWidth: 150,
                leading: StreamBuilder(
                    stream: userDoc.snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      var myInfo = snapshot.data!;

                      return Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Center(
                            child: Text(
                              myInfo['userID'],
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17),
                            ),
                          ),
                        ],
                      );
                    }),
                actions: [
                  IconButton(
                    icon: const Icon(TablerIcons.moon_stars),
                    color: Colors.black,
                    iconSize: 27,
                    onPressed: () {},
                  ),
                ],
              ),
              body: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileCard(
                              ontap: () => showCupertinoModalSheet(
                                context: context,
                                builder: (context) => ProfileTap(
                                  userInfo: snapshot.data!,
                                ),
                              ),
                              userName: snapshot.data!['userName'],
                              userExplain: snapshot.data!['userExplain'],
                              userProfileURL: snapshot.data!['userProfile'],
                              userConnectedNum: snapshot.data!['connected'],
                            ),
                            const SizedBox(height: 10),
                            const ActionRow(),
                            const SizedBox(height: 20),
                            const AcKakaoAds(),
                            const SizedBox(height: 20),
                            const Explains(),
                            const SizedBox(
                                height: 20) // 로그아웃 밑 여백주려고 일부로 만들었으니 삭제하지 마세요.
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }
}
