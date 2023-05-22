import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/GoalListScreen.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/TodoListScreen.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MajorRoomBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/CategoryTypeScreen.dart';
import '../../../InternalTodoScreen/FinanceCalListScreen.dart';
import '../../../InternalTodoScreen/FinanceListScreen.dart';
import '../../../InternalTodoScreen/NewChecklistScreen.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MinorRoomBox.dart';

import '../../../InternalTodoScreen/NewMemoListScreen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  /*
       'title' : '나의 카테고리',
       'dateCreated': DateTime.now(),
       'type' : memo(문자형식으로...)
       'colorNum': Random().nextInt(10)
  */

  void showDeleteDialog(
      BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('정말로 ${item['title']}을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  item.reference.delete();
                  Navigator.pop(context);
                },
                child: const Text(
                  "예",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("아니오"),
              ),
            ],
          );
        });
  }

  void showNameChangeDialog(
      BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('이름 편집'),
              content: TextField(
                controller: TextEditingController(text: item['title']),
                autofocus: true,
                onSubmitted: (String text) {
                  item.reference.update({'title': text});
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                textInputAction: TextInputAction.send,
              ));
        });
  }

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

            return Padding(
                padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                child: Column(children: [
                  MajorRoomBox(
                    upText: '나의 메모',
                    downText: '4시간 전 업데이트',
                    majorRoomBoxColor: const Color.fromARGB(255, 155, 210, 255),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: cateArray.length,
                    itemBuilder: (context, index) {
                      return MinorRoomBox(
                        minorRoomBoxColor: Colors.grey,
                        upText: cateArray[index]['title'],
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                var item = cateArray[index];
                                return SimpleDialog(
                                  title: Text("${item['title']}"),
                                  children: [
                                    SimpleDialogOption(
                                      child: const Text("삭제하기",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDeleteDialog(context, item);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: const Text("이름 바꾸기"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showNameChangeDialog(context, item);
                                      },
                                    ),
                                    SimpleDialogOption(
                                        child: const Text("돌아가기"),
                                        onPressed: () => Navigator.pop(context))
                                  ],
                                );
                              });
                        },
                        ontap: () {
                          if (cateArray[index]['type'] == 'Check List') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChecklistScreen(
                                          myData: cateArray[index]['data'],
                                          checkID: cateArray[index].id,
                                          title: cateArray[index]['title'],
                                        )));
                          } else if (cateArray[index]['type'] == 'To-do List') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TodoListScreen(
                                        todosID: cateArray[index].id,
                                        title: cateArray[index]['title'])));
                          } else if (cateArray[index]['type'] == 'Goal List') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GoalListScreen(
                                        goalsID: cateArray[index].id,
                                        title: cateArray[index]['title'])));
                          } else if (cateArray[index]['type'] == 'Memo List') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemoListScreen(
                                          title: cateArray[index]['title'],
                                          memoID: cateArray[index].id,
                                          myData: cateArray[index]['data'],
                                        )));
                          } else if (cateArray[index]['type'] ==
                              'Finance List') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinanceListScreen(
                                    title: cateArray[index]['title'],
                                    usedMoney: cateArray[index]['usedMoney'],
                                    leftMoney: cateArray[index]['leftMoney'],
                                    limitMoney: cateArray[index]['limitMoney'],
                                    financeID: cateArray[index].id),
                              ),
                            );
                          } else if (cateArray[index]['type'] ==
                              'Finance Calendar List') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinanceCalListScreen(
                                    title: cateArray[index]['title'],
                                    financeCalID: cateArray[index].id),
                              ),
                            );
                          }
                        },
                      );
                    },
                  )),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategoryTypeScreen())),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          foregroundColor: Colors.black,
                          fixedSize: const Size(350, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          side: const BorderSide(color: Colors.grey, width: 2)),
                      child: const Icon(Icons.add))
                ]));
          }),
    );
  }
}
