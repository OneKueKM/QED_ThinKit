import 'package:flutter/material.dart';
import 'package:qed_app_thinkit/InternalTodoScreen/MyMemoEditingScreen.dart';

class MyMemoScreen extends StatefulWidget {
  Map<String, dynamic> memoData;
  String memoID;
  int index;

  MyMemoScreen(
      {Key? key,
        required this.memoData, required this.memoID, required this.index})
      : super(key: key);

  @override
  State<MyMemoScreen> createState() => _MyMemoScreenState();
}

class _MyMemoScreenState extends State<MyMemoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.memoData['title']),
            leading: BackButton(
              onPressed: () => Navigator.pop(context, widget.memoData)
            ),
            actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMemoEditingScreen(
                              index: widget.index,
                              memoID: widget.memoID,
                              memoData: widget.memoData,
                            )));
                    setState(() => widget.memoData = result);
                  }))
        ]),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.memoData['content'],
                style: const TextStyle(fontSize: 20))));
  }
}