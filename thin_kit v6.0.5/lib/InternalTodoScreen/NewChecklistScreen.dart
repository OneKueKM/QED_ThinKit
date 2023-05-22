import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/Main/1_Room/1_Widget/MySlidable.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:flutter/services.dart'; //Haptic Feedback

class ChecklistScreen extends StatefulWidget {
  String? checkID;
  String? title;
  List<dynamic> myData = [];

  ChecklistScreen(
      {Key? key,
      required this.checkID,
      required this.title,
      required this.myData})
      : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

/*  List<Map<String, dynamic>>
 ㄴ String title
 ㄴ bool done
 ㄴ List<Map<String, dynamic> child

   Child 내부
   ㄴ String title
   ㄴ bool done

시작할 때 불러오기 (stream X)
끝낼 때 전부 저장 -> 고친 버전 저장 */

class _ChecklistScreenState extends State<ChecklistScreen> {
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
        .doc(widget.checkID);
    await myDoc.update({'data': FieldValue.delete()});
    await myDoc.update({'data': FieldValue.arrayUnion(widget.myData)});
  }

  @override
  Widget build(BuildContext context) {
    var myDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.checkID);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leadingWidth: 300,
        leading: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Center(
              child: Text(
                widget.title!,
                // ignore: prefer_const_constructors
                style: TextStyle(
                    fontFamily: 'SFProText',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ),
          ],
        ),
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
                            validator: (value) => (value!.isEmpty) ? '제목을 입력하세요.' : null,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            //제목변경
                            if (_formKey.currentState!.validate()) {
                              myDoc.update({
                                'title' : _titleController.text,
                              });
                              setState(() => widget.title = _titleController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("등록하기"),
                        )
                      ],
                    ),
                  );
                }
            );
          },
        )],
      ),
      body: ReorderableListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        shrinkWrap: true,
        children: List.generate(widget.myData.length, (index) {
          var checklist = widget.myData[index];
          var childList = checklist['child'];

          debugPrint(checklist.toString());

          return Column(
            key: ValueKey(index),
            children: [
              MySlidable(
                  editFunction: (context) async {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('이름 편집'),
                              content: TextField(
                                controller: TextEditingController(
                                    text: checklist['title']),
                                autofocus: true,
                                onSubmitted: (String text) {
                                  setState(() => checklist['title'] = text);
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                },
                                textInputAction: TextInputAction.done,
                              ));
                        });
                  },
                  deleteFunction: (ctx) =>
                      setState(() => widget.myData.removeAt(index)),
                  widget: ListTile(
                    minVerticalPadding: 0,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              setState(
                                  () => checklist['done'] = !checklist['done']);
                            },
                            icon: (checklist['done'])
                                ? const Icon(TablerIcons.checks,
                                    color: Colors.green, size: 25)
                                : const Icon(TablerIcons.minus,
                                    color: Colors.grey, size: 25),
                          ),
                          GestureDetector(
                              onTap: () => setState(() =>
                                  checklist['folded'] = !checklist['folded']),
                              child: SizedBox(
                                width: 250,
                                child: Flexible(
                                    child: RichText(
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  strutStyle: const StrutStyle(fontSize: 15),
                                  text: TextSpan(
                                      text: checklist['title'],
                                      style: (checklist['done'])
                                          ? const TextStyle(
                                              fontFamily: 'SFProText',
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17)
                                          : const TextStyle(
                                              fontFamily: 'SFProText',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17)),
                                )),
                              )),
                        ]),
                  )),
              if (!checklist['folded'])
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child: ReorderableListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          var item = childList.removeAt(oldIndex);
                          childList.insert(newIndex, item);
                        });
                      },
                      children: List.generate(
                          childList.length,
                          (i) => MySlidable(
                              key: ValueKey(i),
                              editFunction: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('이름 편집'),
                                    content: TextField(
                                      controller: TextEditingController(
                                          text: childList[i]['title']),
                                      autofocus: true,
                                      onSubmitted: (String text) {
                                        setState(
                                            () => childList[i]['title'] = text);
                                        if (!mounted) return;
                                        Navigator.pop(context);
                                      },
                                      textInputAction: TextInputAction.send,
                                    ));
                              },
                              deleteFunction: (ctx) => setState(() =>
                                  widget.myData[index]['child'].removeAt(i)),
                              widget: ListTile(
                                minVerticalPadding: 0,
                                title: Row(children: [
                                  IconButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      setState(() => childList[i]['done'] =
                                          !childList[i]['done']);
                                    },
                                    icon: (childList[i]['done'])
                                        ? const Icon(TablerIcons.check,
                                            color: Colors.green, size: 17)
                                        : const Icon(TablerIcons.point,
                                            color: Colors.grey, size: 17),
                                  ),
                                  GestureDetector(
                                      onTap: () => setState(() => childList[i]
                                          ['folded'] = !childList[i]['folded']),
                                      child: SizedBox(
                                        width: 220,
                                        child: Flexible(
                                            child: RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          strutStyle:
                                              const StrutStyle(fontSize: 15),
                                          text: TextSpan(
                                              text: childList[i]['title'],
                                              style: (childList[i]['done'])
                                                  ? const TextStyle(
                                                      fontFamily: 'SFProText',
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)
                                                  : const TextStyle(
                                                      fontFamily: 'SFProText',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                        )),
                                      )),
                                ]),
                              )))),
                ),
              if (!checklist['folded'])
                Container(
                  padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('항목 추가'),
                                    content: TextField(
                                        autofocus: true,
                                        onSubmitted: (String text) {
                                          setState(() => checklist['child'].add(
                                              {'title': text, 'done': false}));
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                        },
                                        textInputAction: TextInputAction.send));
                              });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: const Text('하위 항목 추가',
                            style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue)),
                      ),
                    ],
                  ),
                )
            ],
          );
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('New Checklist Tree'),
                  content: TextField(
                    autofocus: true,
                    onSubmitted: (String text) {
                      setState(() => widget.myData.add({
                            'title': text,
                            'done': false,
                            'folded': true,
                            'child': []
                          }));
                      debugPrint('add: ${widget.myData.toString()}');
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    textInputAction: TextInputAction.send,
                  ),
                );
              });
        },
      ),
    );
  }
}
