import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyMemoEditingScreen extends StatefulWidget {
  Map<String, dynamic> memoData;
  String memoID;
  int index;

  MyMemoEditingScreen(
      {Key? key,
      required this.memoData, required this.memoID, required this.index})
      : super(key: key);

  @override
  State<MyMemoEditingScreen> createState() => _MyMemoEditingScreenState();
}

class _MyMemoEditingScreenState extends State<MyMemoEditingScreen> {
  TextEditingController? _contentController;
  TextEditingController? _titleController;
  User? me = FirebaseAuth.instance.currentUser;

  get notOrderedCol => null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memoData['title']);
    _contentController =
        TextEditingController(text: widget.memoData['content']);
  }

  void onSubmitted(text) async {
    Navigator.pop(context, {'title': _titleController!.text, 'content': text});
    var myDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.memoID);
    var myDocData = await myDoc.get();
    var myDocList = myDocData['data'];
    myDocList[widget.index] = {'title': _titleController!.text, 'content': text};
    await myDoc.update({'data': FieldValue.delete()});
    await myDoc.update({'data': FieldValue.arrayUnion(myDocList)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.memoData['title']), actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => onSubmitted(_contentController!.text))
          ),],),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                suffixText: '제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              controller: _titleController,
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              decoration: const InputDecoration(
                prefixText: '내용',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onSubmitted: onSubmitted,
              autofocus: true,
              controller: _contentController,
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
