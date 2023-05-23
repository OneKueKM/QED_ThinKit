import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'FriendDetail.dart';

class BestFriendListWidget extends StatefulWidget {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> bfList;

  BestFriendListWidget({Key? key, required this.bfList}) : super(key: key);

  @override
  State<BestFriendListWidget> createState() => _BestFriendListWidgetState();
}

class _BestFriendListWidgetState extends State<BestFriendListWidget> {
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
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => FriendDetail(
                              myUserInfo: widget.bfList[index],
                              userInfo: myFriend)),
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
