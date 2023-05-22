import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qed_app_thinkit/Main/4_Friends/4_Widget/FriendDetail.dart';
import 'package:tabler_icons/tabler_icons.dart';

class FriendListCard extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> friendInfo;

  FriendListCard({
    Key? key,
    required this.friendInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    DocumentReference<Map<String, dynamic>> ref = friendInfo['ref'];

    return Slidable(
      closeOnScroll: true,
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const BehindMotion(),
        children: [
          if (!friendInfo['favorites'])
            SlidableAction(
              //즐겨찾기
              onPressed: (context) =>
                  friendInfo.reference.update({'favorites': true}),
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              autoClose: true,
              icon: TablerIcons.heart,
            ),
          if (friendInfo['favorites'])
            SlidableAction(
              //즐겨찾기 해제
              onPressed: (context) =>
                  friendInfo.reference.update({'favorites': false}),
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 255, 0, 100),
              autoClose: true,
              icon: TablerIcons.heart_off,
            )
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            //친구삭제
            onPressed: (context) async {
              friendInfo.reference.delete();
              DocumentReference friendDocRef = friendInfo['ref'];
              DocumentReference myDocRef =
                  FirebaseFirestore.instance.collection('Users').doc(me!.uid);
              myDocRef.update({'connected': FieldValue.increment(-1)});
              friendDocRef.update({'connected': FieldValue.increment(-1)});
              var val = await friendDocRef
                  .collection('Friends')
                  .where('ref', isEqualTo: myDocRef)
                  .get();
              val.docs[0].reference.delete();
            },
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 88, 88, 88),
            autoClose: true,
            icon: TablerIcons.eraser,
          )
        ],
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            var friendData = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => FriendDetail(
                          userInfo: friendData, myUserInfo: friendInfo)),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(182, 208, 208, 208),
                                    blurRadius: 3.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 2))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(11)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                friendData['userProfile']))),
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(friendInfo['name'],
                                                style: const TextStyle(
                                                    fontFamily: 'SFProDisplay',
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(height: 5),
                                            Flexible(
                                                child: RichText(
                                              text: TextSpan(
                                                  text:
                                                      friendData['userExplain'],
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'SFProDisplay',
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              strutStyle: const StrutStyle(
                                                  fontSize: 11),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 40,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("${friendData['connected']}",
                                            style: const TextStyle(
                                                fontSize: 19,
                                                color: Color.fromARGB(
                                                    255, 1, 165, 29),
                                                fontFamily: 'SFProDisplay',
                                                fontWeight: FontWeight.w500)),
                                        const Text('연결됨',
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontFamily: 'SFProDisplay',
                                                color: Color.fromARGB(
                                                    255, 1, 165, 29),
                                                fontWeight: FontWeight.w400)),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                )
              ],
            );
          }),
    );
  }
}
