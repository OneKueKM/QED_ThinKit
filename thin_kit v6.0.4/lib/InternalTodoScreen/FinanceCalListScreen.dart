import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class FinanceCalListScreen extends StatefulWidget {
  String financeCalID;
  String title;

  FinanceCalListScreen(
      {Key? key, required this.financeCalID, required this.title})
      : super(key: key);

  @override
  State<FinanceCalListScreen> createState() => _FinanceCalListScreenState();
}

class _FinanceCalListScreenState extends State<FinanceCalListScreen> {
  //제목 제어
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  final _itemFormKey = GlobalKey<FormState>();

  int _onSelectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _titleController = TextEditingController(text: widget.title);
    super.initState();
  }

  void delete(DocumentReference ref){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('정말로 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  ref.delete();
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

  void edit(
      String item, String place, int day, int? price, DocumentReference ref) {
    final itemFormKey = GlobalKey<FormState>();
    TextEditingController itemCon = TextEditingController(text: item);
    TextEditingController placeCon = TextEditingController(text: place);
    TextEditingController dayCon = TextEditingController(text: day.toString());

    late TextEditingController priceCon;
    if(price == null){
      priceCon = TextEditingController();
    }else{
      priceCon = TextEditingController(text: price.toString());
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: itemFormKey,
            child: AlertDialog(
              title: Text("$item 편집하기"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "항목"),
                    controller: itemCon,
                    validator: (value) =>
                        (value!.isEmpty) ? '항목을 입력하세요.' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "장소"),
                    controller: placeCon,
                    validator: (value) =>
                        (value!.isEmpty) ? '장소를 입력하세요.' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "일자"),
                    controller: dayCon,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                        (value!.isEmpty) ? '일자를 입력하세요.' : null,
                  ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "금액"),
                      controller: priceCon,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    //제목추가
                    if (itemFormKey.currentState!.validate()) {
                      await ref.update({
                        'day': int.parse(dayCon.text),
                        'item': itemCon.text,
                        'place': placeCon.text,
                        'price': (priceCon.text.isEmpty)
                            ? null
                            : int.parse(priceCon.text)
                      });
                      if(!mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("등록하기"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final User? me = FirebaseAuth.instance.currentUser;
    final financeCalDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.financeCalID);
    final notOrderedCol = financeCalDoc.collection('Finance Calendar');
    final orderedCol = notOrderedCol.orderBy('day');

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
                              financeCalDoc.update({
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Form(
                  key: _itemFormKey,
                  child: AlertDialog(
                    title: const Text("추가하기"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(hintText: "항목"),
                          controller: _itemController,
                          validator: (value) =>
                              (value!.isEmpty) ? '항목을 입력하세요.' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: "장소"),
                          controller: _placeController,
                          validator: (value) =>
                              (value!.isEmpty) ? '장소를 입력하세요.' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: "일자"),
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              (value!.isEmpty) ? '일자를 입력하세요.' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: "금액"),
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          //제목추가
                          Navigator.pop(context);
                          if (_itemFormKey.currentState!.validate()) {
                            notOrderedCol.add({
                              'day': int.parse(_dayController.text),
                              'item': _itemController.text,
                              'place': _placeController.text,
                              'price': (_priceController.text.isEmpty)
                                  ? null
                                  : int.parse(_priceController.text)
                            });
                          }
                        },
                        child: const Text("등록하기"),
                      )
                    ],
                  ),
                );
              });
        },
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: orderedCol.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var result = snapshot.data!.docs;

              if (result.isEmpty) {
                return const Center(child: Text("추가해요^^"));
              }

              return InViewNotifierList(
                  endNotificationOffset: 400,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: result.length,
                  builder: (BuildContext context, int index) {
                    var item = result[index];
                    var ref = item.reference;

                    return InViewNotifierWidget(
                      id: '$index',
                      builder:
                          (BuildContext context, bool isInView, Widget? child) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text("${item['item']}"),
                                    children: [
                                      SimpleDialogOption(
                                        child: const Text("삭제하기",
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          delete(ref);
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: const Text("바꾸기"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          edit(item['item'], item['place'],
                                              item['day'], item['price'], ref);
                                        },
                                      ),
                                      SimpleDialogOption(
                                          child: const Text("돌아가기"),
                                          onPressed: () =>
                                              Navigator.pop(context))
                                    ],
                                  );
                                });
                          },
                          child: Card(
                              margin: const EdgeInsets.all(20),
                              color: isInView ? Colors.blue : Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                  //버튼을 둥글게 처리
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${item['day']}일",
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: isInView
                                                      ? Colors.yellow
                                                      : Colors.red),
                                            ),
                                            Text(item['item'],
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: isInView
                                                        ? Colors.white
                                                        : Colors.black))
                                          ]),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                          height: 3,
                                          color: isInView
                                              ? Colors.white
                                              : Colors.blue),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("장소: ${item['place']}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: isInView
                                                  ? Colors.white
                                                  : Colors.black)),
                                      if (item['price'] != null)
                                        Text("가격: ${item['price']}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: isInView
                                                    ? Colors.white
                                                    : Colors.black)),
                                    ]),
                              )),
                        );
                      },
                    );
                  },
                  isInViewPortCondition: (double deltaTop, double deltaBottom,
                      double viewPortDimension) {
                    return deltaTop < (0.4 * viewPortDimension) &&
                        deltaBottom > (0.4 * viewPortDimension);
                  });
            }),
      ),
    );
  }
}
