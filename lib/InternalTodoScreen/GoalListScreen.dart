import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalListScreen extends StatefulWidget {
  String goalsID;
  String title;

  GoalListScreen({Key? key, required this.goalsID, required this.title})
      : super(key: key);

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

/* Goal 내부 Map 구조
 Timestamp timeStarted
 Timestamp timeDeadline
 bool done
 String title
*  */

class _GoalListScreenState extends State<GoalListScreen> {
  TextEditingController titleToPlusController = TextEditingController();
  DateTime dueDateToPlus = DateTime.now();

  //제목 제어
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;

    final goalsDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.goalsID);
    final goalsCol = goalsDoc.collection('Goals');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
          color: Colors.black,
          icon: const Icon(Icons.edit_note_sharp),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    child: AlertDialog(
                      title: const Text("제목 수정"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(hintText: "제목"),
                            controller: _titleController,
                            validator: (value) =>
                                (value!.isEmpty) ? '제목을 입력하세요.' : null,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            //제목변경
                            if (_formKey.currentState!.validate()) {
                              goalsDoc.update({
                                'title': _titleController.text,
                              });
                              setState(
                                  () => widget.title = _titleController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("등록하기"),
                        )
                      ],
                    ),
                  );
                });
          },
        )
      ]),
      body: StreamBuilder(
        stream: goalsCol.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final goalArray = snapshot.data!.docs;

          return ListView.builder(
              itemCount: goalArray.length,
              itemBuilder: (BuildContext context, int index) {
                final myGoal = goalArray[index].data();

                return Row(
                  children: [
                    //정보 기록 박스
                    Expanded(
                      flex: 6,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: (myGoal['done'])
                                    ? Colors.green
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            children: [
                              Text(
                                myGoal['title'],
                                style: TextStyle(
                                    fontSize: 20,
                                    decoration: (myGoal['done'])
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: (myGoal['done'])
                                        ? Colors.green
                                        : Colors.black),
                              ),
                              Text(
                                  '${DateFormat('yyyy/MM/dd').format(myGoal['timeDeadline'].toDate())} 까지  |  D-${myGoal['timeDeadline'].toDate().difference(DateTime.now()).inDays}',
                                  style: const TextStyle(color: Colors.grey))
                            ],
                          )),
                    ),
                    //버튼들
                    Expanded(
                      flex: 1,
                      child: Column(children: [
                        //delete check
                        IconButton(
                          icon: Image.asset(
                              'assets/images/baseline_highlight.png'),
                          onPressed: () =>
                              goalsCol.doc(goalArray[index].id).delete(),
                        ),
                        //done check
                        IconButton(
                            icon: const Icon(Icons.done),
                            color:
                                (myGoal['done']) ? Colors.green : Colors.black,
                            onPressed: () => goalsCol
                                .doc(goalArray[index].id)
                                .update({'done': !myGoal['done']})),
                      ]),
                    )
                  ],
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text("새 목표를 입력하시오."),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              decoration:
                                  const InputDecoration(prefixText: '제목'),
                              autofocus: true,
                              controller: titleToPlusController,
                            ),
                            SizedBox(
                              height: 500,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                maximumYear: 2100,
                                backgroundColor: Colors.white,
                                initialDateTime:
                                    DateTime.now().add(const Duration(days: 1)),
                                minimumDate: DateTime.now(),
                                maximumDate: DateTime.now()
                                    .add(const Duration(days: 3000)),
                                onDateTimeChanged: (date) =>
                                    dueDateToPlus = date,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await goalsCol.add({
                                    'title': titleToPlusController.text,
                                    'timeDeadline': dueDateToPlus,
                                    'timeStarted': DateTime.now(),
                                    'done': false,
                                  });
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white70,
                                    foregroundColor: Colors.black,
                                    fixedSize: const Size(350, 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    side: const BorderSide(
                                        color: Colors.grey, width: 2)),
                                child: const Icon(Icons.add))
                          ],
                        ),
                      ));
                });
          }),
    );
  }
}
