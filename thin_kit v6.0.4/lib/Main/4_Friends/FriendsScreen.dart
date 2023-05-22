import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/Main/4_Friends/4_Tap/FriendAddingScreen.dart';
import 'package:qed_app_thinkit/Main/4_Friends/4_Widget/BestFriendListWidget.dart';
import 'package:qed_app_thinkit/Main/4_Friends/4_Widget/SearchBar.dart' as qed;

import 'package:page_transition/page_transition.dart';

import 'package:tabler_icons/tabler_icons.dart';
import '4_Widget/FriendListCard.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser; //접속한 아이디의 UID
    final userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Friends')
        .orderBy('name');
    final favoriteDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(me.uid)
        .collection('Friends')
        .where('favorites', isEqualTo: true);

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
                '친구',
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              TablerIcons.tools,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () => {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const FriendAddingScreen()))
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: qed.SearchBar(),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 20,
              child: const Text(
                '즐겨찾기',
                style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromARGB(255, 99, 99, 99)),
              ),
            ),
            const SizedBox(height: 5),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: favoriteDocRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: 80,
                    child: BestFriendListWidget(
                      bfList: snapshot.data!.docs,
                    ),
                  );
                }),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 20,
              child: const Text(
                '친구',
                style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromARGB(255, 99, 99, 99)),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: userDocRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    var friendList = snapshot.data!.docs;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: friendList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var friend = friendList[index];

                          return FriendListCard(
                            friendInfo: friend,
                          );
                        });
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
