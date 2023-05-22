import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/MyMemoScreen.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MySlidable.dart';
import 'MyMemoEditingScreen.dart';

class MemoListScreen extends StatefulWidget {
  String? memoID;
  String? title;
  List<dynamic> myData = [];

  MemoListScreen({Key? key,
    required this.memoID,
    required this.title,
    required this.myData})
      : super(key: key);

  @override
  State<MemoListScreen> createState() => _MemoListScreenState();
}

/*  List<Map<String, dynamic>>
 ㄴ String title
 ㄴ String content
 */

class _MemoListScreenState extends State<MemoListScreen> {
  User? me = FirebaseAuth.instance.currentUser;

  //제목 제어
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() async {
    super.dispose();
    var myDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.memoID);
    await myDoc.update({'data': FieldValue.delete()});
    await myDoc.update({'data': FieldValue.arrayUnion(widget.myData)});
  }

  @override
  Widget build(BuildContext context) {
    var myDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.memoID);

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title!),
          actions: [
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
                                  myDoc.update({
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
          ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('New Memo'),
                  content: TextField(
                    autofocus: true,
                    onSubmitted: (String text) {
                      setState(() =>
                          widget.myData.add({
                            'title': text,
                            'content': ''
                          }));
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    textInputAction: TextInputAction.send,
                  ),
                );
              });
        },
      ),
      body: ReorderableListView(
        children: List.generate(widget.myData.length,
            (index){
          var memo = widget.myData[index];

          return MySlidable(
            key: ValueKey(index),
              editFunction: (ctx) async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyMemoEditingScreen(
                          memoID: widget.memoID!,
                          index: index,
                          memoData: memo,
                        )));
                if(result != null){
                  setState(() => widget.myData[index] = result);
                }
              }, //편집하기
              deleteFunction: (ctx) => setState(() => widget.myData.removeAt(index)), //삭제하기
              widget: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyMemoScreen(
                            memoID: widget.memoID!,
                           index: index,
                           memoData: memo, //다음 화면으로 전환
                         )));
                 setState(() => widget.myData[index] = result);
                },
                child: ListTile(
                  title: Text(memo['title'], style: const TextStyle(fontSize: 25),)
                ),
              ));
            }),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item = widget.myData.removeAt(oldIndex);
            widget.myData.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
