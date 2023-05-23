import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Type {
  checkList,
  todoList,
  goalList,
  memoList,
  financeList,
  financeCalList
}

/* 카테고리 생성 시 카테고리명, 양식 설정 화면 */
class CategoryTypeScreen extends StatefulWidget {
  const CategoryTypeScreen({super.key});

  @override
  State<CategoryTypeScreen> createState() => _CategoryTypeScreenState();
}

class _CategoryTypeScreenState extends State<CategoryTypeScreen> {
  TextEditingController _titleController = TextEditingController();
  Type _type = Type.checkList;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    final notOrderedCol = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories');

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
              child: Row(
                children: const [
                  Text("제목",
                      style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 15,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            TextFormField(
                style: const TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.black),
                showCursor: false,
                textAlignVertical: TextAlignVertical.bottom,
                controller: _titleController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 188, 188, 188)),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    hintText: '카테고리 제목'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                }),
            const SizedBox(height: 20),
            /* 메모장 양식 선택 버튼 */
            SizedBox(
              height: 25,
              child: Row(
                children: const [
                  Text("카테고리 타입 선택",
                      style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 15,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
                title: const Text("CheckList"),
                leading: Radio(
                  value: Type.checkList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),
            ListTile(
                title: const Text("To-do List"),
                leading: Radio(
                  value: Type.todoList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),
            ListTile(
                title: const Text("Goal List"),
                leading: Radio(
                  value: Type.goalList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),
            ListTile(
                title: const Text("Memo List"),
                leading: Radio(
                  value: Type.memoList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),
            ListTile(
                title: const Text("Finance List"),
                leading: Radio(
                  value: Type.financeList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),
            ListTile(
                title: const Text("Finance Calendar"),
                leading: Radio(
                  value: Type.financeCalList,
                  groupValue: _type,
                  onChanged: (Type? val) => setState(() => _type = val!),
                )),

            /* 카테고리 생성 버튼 */
            ElevatedButton(
                onPressed: () async {
                  if (_titleController.text == '') {
                    Get.snackbar('Error', '내용을 입력하세요!');
                  } else {
                    await notOrderedCol.add({
                      'title': _titleController.text,
                      'dateCreated': DateTime.now(),
                      'type': (_type == Type.checkList)
                          ? "Check List"
                          : (_type == Type.todoList)
                              ? "To-do List"
                              : (_type == Type.goalList)
                                  ? "Goal List"
                                  : (_type == Type.memoList)
                                      ? "Memo List"
                                      : (_type == Type.financeList)
                                          ? "Finance List"
                                          : "Finance Calendar List",
                      'colorNum': Random().nextInt(10),
                      if (_type == Type.checkList || _type == Type.memoList)
                        'data': [],
                      if (_type == Type.financeList) 'leftMoney': 0,
                      if (_type == Type.financeList) 'usedMoney': 0,
                      if (_type == Type.financeList) 'limitMoney': 0,
                    });
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(350, 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(color: Colors.grey, width: 2)),
                child: const Text("추가"))
          ],
        ),
      ),
    ));
  }
}
