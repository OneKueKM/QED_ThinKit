import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:tabler_icons/tabler_icons.dart';

class ReqSender extends StatefulWidget {
  ReqSender(
      {Key? key, required this.friendRequesting, required this.friendRequested})
      : super(key: key);
  List<dynamic> friendRequested;
  List<dynamic> friendRequesting;

  @override
  State<ReqSender> createState() => _ReqSenderState();
}

class _ReqSenderState extends State<ReqSender> {
  final User? me = FirebaseAuth.instance.currentUser;
  final TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool waiting = false;
  bool searched = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? result;
  bool isAlreadyMyFriend = false;
  bool isAlreadyFriendRequested = false;
  bool isAlreadyFriendRequesting = false;

  @override
  Widget build(BuildContext context) {
    final myDocRef =
        FirebaseFirestore.instance.collection('Users').doc(me!.uid);
    final friendListCol = myDocRef.collection('Friends');

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* 추가할 친구를 탐색하는 파트 */
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: "친구의 ID",
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                          width: 5,
                        ))),
                    controller: idController,
                    validator: (text) {
                      return (text == '') ? '값을 입력하시오.' : null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    iconSize: 50,
                    onPressed: () async {
                      //친구 탐색
                      if (_formKey.currentState!.validate()) {
                        setState(() => {searched = true, waiting = true});
                        result = (await FirebaseFirestore.instance
                                .collection('Users')
                                .where('userID', isEqualTo: idController.text)
                                .limit(1)
                                .get())
                            .docs;
                        if (result!.isNotEmpty) {
                          isAlreadyMyFriend = (await friendListCol
                                  .where('ref', isEqualTo: result![0].reference)
                                  .get())
                              .docs
                              .isNotEmpty;
                          isAlreadyFriendRequested = widget.friendRequested
                              .contains(result![0].reference);
                          isAlreadyFriendRequesting = widget.friendRequesting
                              .contains(result![0].reference);
                        }
                        setState(() => {waiting = false, isAlreadyMyFriend});
                      }
                    },
                    icon: const Icon(Icons.person_add_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (!searched)
            const Expanded(
                child: Center(
                    child: Text("데이터 입력 전", style: TextStyle(fontSize: 45)))),
          if (searched && waiting)
            const Expanded(
                child: Center(child: CircularProgressIndicator(value: 30))),
          if (searched && !waiting && result!.isEmpty)
            const Expanded(
                child: Center(
                    child: Text("찾고자 하는\n데이터가 없습니다.",
                        style: TextStyle(fontSize: 32)))),
          if (searched && !waiting && result!.isNotEmpty)
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(result![0]['userProfile']))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(result![0]['userName'],
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 20),
                if (isAlreadyMyFriend)
                  TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black),
                    child: const Text("당신의 친구", style: TextStyle(fontSize: 20)),
                  ),
                if (isAlreadyFriendRequesting)
                  TextButton(
                      onPressed: () {
                        //친구 요청 취소 동작
                        var myDocRef = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(me!.uid);
                        var friendDocRef = result![0].reference;
                        friendDocRef.update({
                          'friendRequested': FieldValue.arrayRemove([myDocRef])
                        });
                        myDocRef.update({
                          'friendRequesting':
                              FieldValue.arrayRemove([friendDocRef])
                        });
                        setState(() => isAlreadyFriendRequesting = false);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black),
                      child: const Text("친구 요청 취소",
                          style: TextStyle(fontSize: 20))),
                if (isAlreadyFriendRequested)
                  TextButton(
                      onPressed: () async {
                        //친구 수락 완료 동작
                        Get.snackbar('친구 수락 완료',
                            '${result![0].data()['userName']} 친구 추가 완료');
                        var friendDocRef = result![0].reference;
                        myDocRef.update({
                          'friendRequested':
                              FieldValue.arrayRemove([friendDocRef]),
                          'connected': FieldValue.increment(1)
                        });
                        friendDocRef.update({
                          'friendRequesting':
                              FieldValue.arrayRemove([myDocRef]),
                          'connected': FieldValue.increment(1)
                        });
                        friendListCol.add({
                          'ref': result![0].reference,
                          'name': result![0]['userName'],
                          'favorites': false
                        });
                        String myName = (await myDocRef.get())['userName'];
                        friendDocRef.collection('Friends').add({
                          'ref': myDocRef,
                          'name': myName,
                          'favorites': false
                        });

                        setState(() => {
                              isAlreadyFriendRequested = false,
                              isAlreadyMyFriend = true
                            });
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black),
                      child: const Text("친구 요청 수락",
                          style: TextStyle(fontSize: 20))),
                if (!(isAlreadyMyFriend ||
                    isAlreadyFriendRequesting ||
                    isAlreadyFriendRequested))
                  TextButton(
                    onPressed: () {
                      Get.snackbar('친구 요청 완료', '친구 추가를 요청하였습니다.');
                      var myDocRef = FirebaseFirestore.instance
                          .collection('Users')
                          .doc(me!.uid);
                      var friendDocRef = result![0].reference;
                      myDocRef.update({
                        'friendRequesting':
                            FieldValue.arrayUnion([friendDocRef])
                      });
                      friendDocRef.update({
                        'friendRequested': FieldValue.arrayUnion([myDocRef])
                      });
                      setState(() => isAlreadyFriendRequesting = true);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black),
                    child: const Text("친구 추가", style: TextStyle(fontSize: 20)),
                  )
              ],
            ))
        ],
      ),
    );
  }
}
