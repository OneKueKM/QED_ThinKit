import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:qed_app_thinkit/Main/1_Room/1_Tap/CategoryListScreen.dart';
import 'package:qed_app_thinkit/Main/3_Home/3_Tap/NewNotiTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/1_Team_Tap_MakeTeam/MakeTeamsTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Team/1_Team_Tap/TeamTap.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MajorRoomBox.dart';

import 'package:page_transition/page_transition.dart';
import 'package:tabler_icons/tabler_icons.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser; //접속한 아이디의 UID
    final currentUserRef =
        FirebaseFirestore.instance.collection('Users').doc(me!.uid);
    final friendsCol = FirebaseFirestore.instance
        .collection('Users')
        .doc(me.uid)
        .collection('Friends')
        .orderBy('name');

    /* 엉성하지만 데이터 한번만 가져오기 성공! */
    String myName = '';
    FirebaseFirestore.instance
        .collection('Users')
        .doc(me.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      myName = data['userName'];
    });

    return StreamBuilder(
        stream: friendsCol.snapshots(),
        builder: (context, snapshot) {
          final friendsDataList = snapshot.data?.docs;

          if (friendsDataList != null) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakeTeamsTap(
                                      friendsDataList: friendsDataList,
                                      currentUserRef: currentUserRef,
                                      currentUserName: myName,
                                    ))).then((value) {
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.people,
                        color: Colors.grey,
                        size: 30,
                      )),
                  /* 알림 종 아이콘 구현부(앱바 오른쪽) */
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(TablerIcons.bell),
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () => {
                        HapticFeedback.lightImpact(),
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const NewNotiTap()))
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: MajorRoomBox(
                            upText: '개인 메모',
                            downText: 'Partly Private',
                            majorRoomBoxColor:
                                const Color.fromARGB(255, 155, 210, 255),
                            ontap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryListScreen(),
                                    ));
                              });
                            }),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(me.uid)
                                .collection('MyTeam')
                                .orderBy('favorites', descending: true)
                                .get(),
                            builder: (context, snapshot) {
                              final myTeamsList = snapshot.data?.docs;

                              if (myTeamsList != null) {
                                if (myTeamsList.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: myTeamsList.length,
                                      itemBuilder: (context, index) {
                                        DocumentReference teamRef =
                                            myTeamsList[index]['teamRef'];
                                        return FutureBuilder(
                                            future: teamRef.get(),
                                            builder: (context, snapshot) {
                                              final teamData = snapshot.data;
                                              if (teamData != null) {
                                                return Slidable(
                                                  startActionPane: ActionPane(
                                                    extentRatio: 0.2,
                                                    motion:
                                                        const BehindMotion(),
                                                    children: [
                                                      myTeamsList[index]
                                                              ['favorites']
                                                          ? SlidableAction(
                                                              //즐겨찾기 해제
                                                              onPressed:
                                                                  (context) {
                                                                myTeamsList[
                                                                        index]
                                                                    .reference
                                                                    .update({
                                                                  'favorites':
                                                                      false
                                                                });
                                                                setState(() {});
                                                              },
                                                              backgroundColor:
                                                                  Colors.white,
                                                              foregroundColor:
                                                                  Colors.grey,
                                                              autoClose: true,
                                                              icon: Icons.star,
                                                            )
                                                          : SlidableAction(
                                                              //즐겨찾기
                                                              onPressed:
                                                                  (context) {
                                                                myTeamsList[
                                                                        index]
                                                                    .reference
                                                                    .update({
                                                                  'favorites':
                                                                      true
                                                                });
                                                                setState(() {});
                                                              },
                                                              backgroundColor:
                                                                  Colors.white,
                                                              foregroundColor:
                                                                  Colors.grey,
                                                              autoClose: true,
                                                              icon: Icons
                                                                  .star_border,
                                                            ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 10, 15, 10),
                                                    child: MajorRoomBox(
                                                      upText:
                                                          teamData['teamName'],
                                                      downText:
                                                          '${teamData['teamMembers'].length}명',
                                                      majorRoomBoxColor:
                                                          const Color(
                                                              0xffbd46ea),
                                                      favorites:
                                                          myTeamsList[index]
                                                              ['favorites'],
                                                      ontap: () {
                                                        Navigator.of(
                                                          context,
                                                          rootNavigator: true,
                                                        )
                                                            .push(
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .rightToLeft,
                                                            child: TeamTap(
                                                              currentUserRef:
                                                                  currentUserRef,
                                                              teamRef: teamRef,
                                                              selectedDate: DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day),
                                                            ),
                                                          ),
                                                        )
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            });
                                      });
                                } else {
                                  return const Center(
                                      child: Text('함께할 팀을 만들어보세요',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          )));
                                }
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ));
          } else {
            return Container();
          }
        });
  }
}
