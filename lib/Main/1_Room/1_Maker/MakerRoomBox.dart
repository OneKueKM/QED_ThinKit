import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/GoalListScreen.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/TodoListScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../InternalTodoScreen/NewChecklistScreen.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MinorRoomBox.dart';

class MakeRoomBox extends StatelessWidget {
  const MakeRoomBox({super.key});

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    final notOrderedCol = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories');
    final cateCol = notOrderedCol.orderBy('dateCreated', descending: true);

    return Scaffold(
        body: StreamBuilder(
            stream: cateCol.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final cateArray = snapshot.data!.docs;

              return SafeArea(
                child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                        itemBuilder: (context, index) => SizedBox(
                              height: 400,
                              child: Column(
                                children: [
                                  MinorRoomBox(
                                    minorRoomBoxColor: Colors.grey,
                                    upText: cateArray[index]['title'],
                                    downText: '2시간 전 수정',
                                    ontap: () {
                                      if (cateArray[index]['type'] ==
                                          'Check List') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChecklistScreen(
                                                      myData: cateArray[index]
                                                          ['data'],
                                                      checkID:
                                                          cateArray[index].id,
                                                      title: cateArray[index]
                                                          ['title'],
                                                    )));
                                      } else if (cateArray[index]['type'] ==
                                          'To-do List') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TodoListScreen(
                                                        todosID:
                                                            cateArray[index].id,
                                                        title: cateArray[index]
                                                            ['title'])));
                                      } else if (cateArray[index]['type'] ==
                                          'Goal List') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GoalListScreen(
                                                        goalsID:
                                                            cateArray[index].id,
                                                        title: cateArray[index]
                                                            ['title'])));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ))),
              );
            }));
  }
}
