import 'package:flutter/material.dart';

/* 내부 패키지 */
import 'package:get/get.dart';

/* 서버 패키지 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabler_icons/tabler_icons.dart';

//friendReqCard가 요청한 친구들인 경우 requesting = true
//friendReqCard가 요청받은 친구들의 경우 requested = true

class friendReqCard extends StatelessWidget {
  DocumentSnapshot<Map<String, dynamic>> friendInfo;
  bool requesting;
  bool requested;
  void Function()? ontap;
  void Function()? remove;

  friendReqCard(
      {Key? key,
      required this.friendInfo,
      this.requested = false,
      this.requesting = false,
      this.ontap,
      this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    var myDocRef = FirebaseFirestore.instance.collection('Users').doc(me!.uid);

    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Container(
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
                                          friendInfo['userProfile']))),
                            ),
                            const SizedBox(width: 15),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 170,
                                  height: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(friendInfo['userName'],
                                          style: const TextStyle(
                                              fontFamily: 'SFProDisplay',
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (requesting)
                          GestureDetector(
                              onTap: () {
                                //친구 요청 취소
                                var friendDocRef = friendInfo.reference;
                                friendDocRef.update({
                                  'friendRequested':
                                      FieldValue.arrayRemove([myDocRef])
                                });
                                myDocRef.update({
                                  'friendRequesting':
                                      FieldValue.arrayRemove([friendDocRef])
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    TablerIcons.x,
                                    color: Colors.white,
                                    size: 17,
                                  ))),
                        if (requested)
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {/*받은 요청 삭제*/},
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        TablerIcons.x,
                                        color: Colors.white,
                                        size: 17,
                                      ))),
                              const SizedBox(width: 10),
                              GestureDetector(
                                  //친구 수락 버튼
                                  onTap: () async {
                                    //친구 수락 및 추가
                                    var friendDocRef = friendInfo.reference;
                                    Get.snackbar('친구 수락 완료',
                                        '${friendInfo['userName']}님과 연결되었습니다.');
                                    myDocRef.update({
                                      'friendRequested': FieldValue.arrayRemove(
                                          [friendDocRef]),
                                      'connected': FieldValue.increment(1)
                                    });
                                    friendDocRef.update({
                                      'friendRequesting':
                                          FieldValue.arrayRemove([myDocRef]),
                                      'connected': FieldValue.increment(1)
                                    });
                                    myDocRef.collection('Friends').add({
                                      'ref': friendInfo.reference,
                                      'name': friendInfo['userName'],
                                      'favorites': false
                                    });
                                    String myName =
                                        (await myDocRef.get())['userName'];
                                    friendDocRef.collection('Friends').add({
                                      'ref': myDocRef,
                                      'name': myName,
                                      'favorites': false
                                    });
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        TablerIcons.check,
                                        color: Colors.white,
                                        size: 17,
                                      ))),
                            ],
                          ),
                        const SizedBox(width: 10)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
