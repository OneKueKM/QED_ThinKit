import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../4_Tap/FriendDetail.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class BestFriend extends StatefulWidget {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> bfList;

  BestFriend({Key? key, required this.bfList}) : super(key: key);

  @override
  State<BestFriend> createState() => _BestFriendState();
}

class _BestFriendState extends State<BestFriend> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.bfList.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentReference<Map<String, dynamic>> bfRef =
              widget.bfList[index]['ref'];

          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: bfRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                var myFriend = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                      onTap: () {
                        SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.manual,
                          overlays: [SystemUiOverlay.bottom],
                        );
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: FriendDetail(
                              userInfo: myFriend,
                              myUserInfo: widget.bfList[index],
                            ),
                          ),
                        ).then((value) {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: [
                                SystemUiOverlay.bottom,
                                SystemUiOverlay.top
                              ]);
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        myFriend!['userProfile']))),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                              height: 15,
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: RichText(
                                    text: const TextSpan(
                                        text: '이름추가',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'SFProDisplay',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    strutStyle: const StrutStyle(fontSize: 11),
                                  )),
                                ],
                              ))
                        ],
                      )),
                );
              });
        },
      ),
    );
  }
}
