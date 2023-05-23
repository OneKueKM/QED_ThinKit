import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementDetailCommentBox extends StatelessWidget {
 final DocumentReference announcementRef;
 final DocumentReference currentUserRef;
 final void Function() refresh;

 const TeamAnnouncementDetailCommentBox(
      {required this.announcementRef,
      required this.currentUserRef,
      required this.refresh,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 80,
        ),
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
                bottom: BorderSide(color: Color.fromARGB(255, 222, 222, 222)))),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: '댓글을 남겨보세요.',
                    border: InputBorder.none,
                  ),
                  controller: commentController,
                  minLines: 1,
                  maxLines: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (commentController.text != '') {
                    HapticFeedback.lightImpact();
                    final comment = <String, dynamic>{
                      'commentContent': commentController.text,
                      'commenterRef': currentUserRef,
                      'commentDate': DateTime.now(),
                    };
                    announcementRef.collection('Comments').add(comment);
                    /*딜레이를 줘서 댓글이 등록되는 느낌을 줌*/
                    Future.delayed(const Duration(milliseconds: 200), () {
                      FocusScope.of(context).unfocus();
                      refresh.call();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  elevation: 0,
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
