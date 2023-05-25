import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class FinanceCalScreen extends StatefulWidget {
  String financeCalID;
  String title;

  FinanceCalScreen({Key? key, required this.financeCalID, required this.title})
      : super(key: key);

  @override
  State<FinanceCalScreen> createState() => _FinanceCalScreenState();
}

class _FinanceCalScreenState extends State<FinanceCalScreen> {
  //제목 제어
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  final _itemFormKey = GlobalKey<FormState>();
  int _onSelectedIndex = 0;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    super.initState();
  }

  void delete(DocumentReference ref) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('정말로 삭제하시겠습니까?'),
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

  void edit(String item, int day, int price, DocumentReference ref) {
    final itemFormKey = GlobalKey<FormState>();
    TextEditingController itemCon = TextEditingController(text: item);
    TextEditingController dayCon = TextEditingController(text: day.toString());

    late TextEditingController priceCon;
    priceCon = TextEditingController(text: price.toString());

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
                    if (itemFormKey.currentState!.validate()) {
                      await ref.update({
                        'day': int.parse(dayCon.text),
                        'item': itemCon.text,
                        'price': int.parse(priceCon.text)
                      });
                      if (!mounted) return;
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
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 247, 247, 247),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(TablerIcons.chevron_left),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
                fontFamily: 'SFProText',
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17),
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: const Icon(TablerIcons.pencil_minus, size: 22),
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
                                decoration:
                                    const InputDecoration(hintText: "제목"),
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
                                  setState(() =>
                                      widget.title = _titleController.text);
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
                          Navigator.pop(context);
                          if (_itemFormKey.currentState!.validate()) {
                            notOrderedCol.add({
                              'day': int.parse(_dayController.text),
                              'item': _itemController.text,
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
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            SizedBox(
              height: 150,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: orderedCol.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    var result = snapshot.data!.docs;

                    int sum = 0;

                    for (var item in result) {
                      sum += int.parse(item['price'].toString());
                    }

                    return Container(
                      color: Colors.red,
                      child: Text('$sum'),
                    );
                  }),
            ),
            Center(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: orderedCol.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    var result = snapshot.data!.docs;

                    if (result.isEmpty) {
                      return const Center(child: Text("금융 일정을 관리해보세요!"));
                    }

                    return InViewNotifierList(
                        endNotificationOffset: 400,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: result.length,
                        builder: (BuildContext context, int index) {
                          var item = result[index];
                          var ref = item.reference;

                          return InViewNotifierWidget(
                            id: '$index',
                            builder: (BuildContext context, bool isInView,
                                Widget? child) {
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
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  delete(ref);
                                                },
                                              ),
                                              SimpleDialogOption(
                                                child: const Text("바꾸기"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  edit(
                                                      item['item'],
                                                      item['day'],
                                                      item['price'],
                                                      ref);
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
                                  child: SizedBox(
                                    height: 90,
                                    child: Card(
                                        margin: const EdgeInsets.fromLTRB(
                                            25, 10, 25, 10),
                                        color: isInView
                                            ? const Color.fromARGB(
                                                255, 109, 189, 255)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        elevation: 3.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                        width: 30,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${item['day']}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SFProText',
                                                                  color: isInView
                                                                      ? Colors
                                                                          .yellow
                                                                      : Colors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 19),
                                                            ),
                                                          ],
                                                        )),
                                                    const VerticalDivider(
                                                      color: Colors.red,
                                                      width: 20,
                                                      thickness: 2.5,
                                                      indent: 7,
                                                      endIndent: 7,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    SizedBox(
                                                        width: 130,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                                child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              strutStyle:
                                                                  const StrutStyle(
                                                                      fontSize:
                                                                          17),
                                                              text: TextSpan(
                                                                  text: item[
                                                                      'item'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'SFProText',
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        17,
                                                                  )),
                                                            ))
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (item['price'] != null)
                                                      Text(
                                                        "${item['price']}",
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'SFProText',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 17),
                                                      ),
                                                  ],
                                                )
                                              ]),
                                        )),
                                  ));
                            },
                          );
                        },
                        isInViewPortCondition: (double deltaTop,
                            double deltaBottom, double viewPortDimension) {
                          return deltaTop < (0.4 * viewPortDimension) &&
                              deltaBottom > (0.4 * viewPortDimension);
                        });
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
