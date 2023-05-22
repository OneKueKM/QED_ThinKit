import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qed_app_thinkit/BasicWidgets/MainCalendar.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListScreen extends StatefulWidget {
  String? todosID;
  String? title;

  TodoListScreen({Key? key, required this.todosID, required this.title})
      : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime dateToPlus = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  TextEditingController titleToPlusController = TextEditingController();

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

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
    final todoDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.todosID);
    final todoCol = todoDoc
        .collection('Todos');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title!), actions: [
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
                              todoDoc.update({
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
      body: SafeArea(
        child: StreamBuilder(
            stream: todoCol.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var todos = snapshot.data!.docs;

              var selectedTodos = todos.where((todo) {
                return todo
                        .data()['startingDate']
                        .toDate()
                        .difference(selectedDate)
                        .inDays ==
                    0;
              }).toList();

              debugPrint(selectedTodos.toString());

              return Column(children: [
                //달력
                MainCalendar(
                  selectedDate: selectedDate,
                  onDaySelected: onDaySelected,
                  calendarFormat: CalendarFormat.week,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedTodos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          //박스
                          Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(selectedTodos[index]['title'],
                                        style: const TextStyle(fontSize: 20)),
                                    Text(
                                        DateFormat.Hm().format(
                                            selectedTodos[index]['startingDate']
                                                .toDate()),
                                        style:
                                            const TextStyle(color: Colors.grey))
                                  ],
                                ),
                              )),
                          //삭제 여부 확인
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Image.asset(
                                  'assets/images/baseline_highlight.png'),
                              onPressed: () =>
                                  todoCol.doc(selectedTodos[index].id).delete(),
                            ),
                          )
                        ]),
                      );
                    },
                  ),
                )
              ]);
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('새 일정을 입력하시오.'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          //제목 입력칸
                          TextField(
                            decoration: const InputDecoration(prefixText: '제목'),
                            autofocus: true,
                            controller: titleToPlusController,
                          ),
                          //날짜 설정 입력란
                          SizedBox(
                            height: 500,
                            child: CupertinoDatePicker(
                              maximumYear: 1,
                              backgroundColor: Colors.white,
                              initialDateTime: DateTime.now(),
                              use24hFormat: true,
                              minimumDate: DateTime.now()
                                  .subtract(const Duration(days: 1)),
                              maximumDate:
                                  DateTime.now().add(const Duration(days: 300)),
                              onDateTimeChanged: (date) => dateToPlus = date,
                            ),
                          ),
                          //완료 버튼
                          ElevatedButton(
                              onPressed: () async {
                                await todoCol.add({
                                  'title': titleToPlusController.text,
                                  'startingDate': dateToPlus,
                                });
                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white70,
                                  foregroundColor: Colors.black,
                                  fixedSize: const Size(350, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  side: const BorderSide(
                                      color: Colors.grey, width: 2)),
                              child: const Icon(Icons.add))
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
