import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../4_Widget/FriendReqCard.dart';
import 'FriendListCard.dart';

class FriendListWidget extends StatefulWidget {
  List<dynamic> friendRefList;
  List<dynamic> bestFriendRefList;
  bool requested;
  bool requesting;

  FriendListWidget(
      {Key? key,
      required this.friendRefList,
      this.bestFriendRefList = const [],
      this.requested = false,
      this.requesting = false})
      : super(key: key);

  @override
  State<FriendListWidget> createState() => _FriendListWidgetState();
}

class _FriendListWidgetState extends State<FriendListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.friendRefList.length,
        itemBuilder: (context, index) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: widget.friendRefList[index].snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                if (widget.requesting) {
                  return friendReqCard(
                      friendInfo: snapshot.data!,
                      requesting: true,
                      remove: () => initState());
                } else {
                  return friendReqCard(
                      friendInfo: snapshot.data!,
                      requested: true,
                      remove: () => initState());
                }
              });
        });
  }
}
