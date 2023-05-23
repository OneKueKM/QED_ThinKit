import 'package:flutter/material.dart';

import 'package:qed_app_thinkit/BasicWidgets/DateTimeToStr.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementDetailCommentCard extends StatelessWidget {
  final String commentContent;
  final DateTime commentDate;
  final DocumentReference commenterRef;
  final void Function() commentDelFunc;

  const TeamAnnouncementDetailCommentCard(
      {required this.commentContent,
      required this.commentDate,
      required this.commenterRef,
      required this.commentDelFunc,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: commentDelFunc, // 내 댓글은 삭제 가능하게 구현
      child: FutureBuilder(
          future: commenterRef.get(),
          builder: (context, snapshot) {
            final commenterData = snapshot.data;

            if (commenterData != null) {
              return Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border:
                                  Border.all(color: const Color(0xfff1efef)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      commenterData['userProfile'])),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(commenterData['userName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      overflow: TextOverflow.ellipsis)),
                              Text(
                                DateTimeToStr(commentDate),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 60),
                          Text(
                            commentContent,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 17.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
