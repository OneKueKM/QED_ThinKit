import 'package:flutter/material.dart';

import 'package:tabler_icons/tabler_icons.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../4_Maker/FriendCard.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final User? me = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool waiting = false;
  bool searched = false;
  List<dynamic> result = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: const Color.fromARGB(255, 233, 233, 233)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          const Icon(
            TablerIcons.search,
            color: Color.fromARGB(255, 99, 99, 99),
            size: 17,
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 315,
            height: 30,
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 233, 233, 233)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(11))),
                          contentPadding: EdgeInsets.all(0),
                          hintText: "검색",
                          hintStyle: TextStyle(fontSize: 13)),
                      controller: _nameController,
                      validator: (text) {
                        return (text == '') ? '값을 입력하시오.' : null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      iconSize: 25,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          result = [];
                          var friendCol = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(me!.uid)
                              .collection('Friends');
                          setState(() => {searched = true, waiting = true});
                          var searchedItems = (await friendCol
                                  .where('name',
                                      isEqualTo: _nameController.text)
                                  .get())
                              .docs;
                          for (var item in searchedItems) {
                            var friend = await item['ref'].get();
                            result.add(friend);
                          }
                          setState(() => waiting = false);
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 233, 233, 233),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!searched)
            /* 데이터 입력 전이면 출력 */
            const Expanded(
                child: Center(child: Text("", style: TextStyle(fontSize: 45)))),
          if (searched && waiting)
            const Expanded(
                child: Center(child: CircularProgressIndicator(value: 30))),
          if (searched && !waiting && result.isEmpty)
            /* 데이터가 없으면 출력 */
            const Expanded(
                child: Center(
                    child: Text("찾고자 하는\n데이터가 없습니다.",
                        style: TextStyle(fontSize: 32)))),
          if (searched && !waiting && result.length == 1)
            /* 결괏값으로 나온 친구가 1인이면 출력 */
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(40),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              NetworkImage(result[0].data()['userProfile']))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(result[0].data()['userName'],
                    style: const TextStyle(fontSize: 32)),
              ],
            )),
          if (searched && !waiting && result.length > 1)
            /* 결괏값으로 나온 친구가 2인 이상이면 출력 */
            ListView.builder(
              shrinkWrap: true,
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                return FriendCard(
                  friendInfo: result[index],
                );
              },
            )
        ],
      ),
    );
  }
}
