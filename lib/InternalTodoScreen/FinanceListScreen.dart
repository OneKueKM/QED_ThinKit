import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Main/1_Room/1_Widget/FinanceAlertDialog.dart';
import '../Main/1_Room/1_Widget/FinanceSpendHistory.dart';

class FinanceListScreen extends StatefulWidget {
  String financeID;
  String title;
  int usedMoney;
  int leftMoney;
  int limitMoney;

  FinanceListScreen({
    Key? key,
    required this.financeID,
    required this.title,
    required this.usedMoney,
    required this.leftMoney,
    required this.limitMoney,
  }) : super(key: key);

  @override
  State<FinanceListScreen> createState() => _FinanceListScreenState();
}

class _FinanceListScreenState extends State<FinanceListScreen> {
  int showMonth = DateTime.now().month;
  DateTime now = DateTime.now();
  final User? me = FirebaseAuth.instance.currentUser;
  bool isLatestOrder = true;
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  //inside Form
  late TextEditingController _titleController;
  late TextEditingController _moneyController;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _moneyController =
        TextEditingController(text: widget.limitMoney.toString());

  }

  @override
  Widget build(BuildContext context) {
    final financeDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(me!.uid)
        .collection('Categories')
        .doc(widget.financeID);
    final userColRef = financeDocRef.collection('Finance');



    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 174, 170, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leadingWidth: 300,
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
                              //장소
                              decoration: const InputDecoration(hintText: "제목"),
                              controller: _titleController,
                              validator: (value) =>
                                  (value!.isEmpty) ? '제목을 입력하세요.' : null,
                            ),
                            TextFormField(
                              //금액
                              decoration:
                                  const InputDecoration(hintText: "한도금액"),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _moneyController,
                              validator: (value) =>
                                  (value!.isEmpty) ? '금액을 입력하세요.' : null,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              //제목변경
                              if (_formKey.currentState!.validate()) {
                                financeDocRef.update({
                                  'title': _titleController.text,
                                  'limitMoney':
                                      int.parse(_moneyController.text),
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
        ],
        leading: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Center(
              child: Text(
                widget.title,
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FinanceAlertDialog(
                    addItem: (price, place, item, isConsume, dateSet) async {
                  var docRef = userColRef.doc(dateSet.toString());
                  if ((await docRef.get()).exists) {
                    docRef.update({
                      'data': FieldValue.arrayUnion([
                        {
                          'price': (isConsume) ? -price : price,
                          'place': place,
                          'item': item,
                        }
                      ]),
                      'amountSum': (isConsume)
                          ? FieldValue.increment(-price)
                          : FieldValue.increment(price)
                    });
                  } else {
                    docRef.set({
                      'date': dateSet,
                      'limitMoney': 0,
                      'amountSum': (isConsume) ? -price : price,
                      'data': [
                        {
                          'price': (isConsume) ? -price : price,
                          'place': place,
                          'item': item,
                        }
                      ],
                    });
                  }

                  if (isConsume) {
                    //소비했으니까 소비금액 늘리기 잔여금액 줄이고
                    financeDocRef.update({
                      'usedMoney': FieldValue.increment(price),
                      'leftMoney': FieldValue.increment(-price)
                    });
                    setState(() {
                      widget.leftMoney -= price;
                      widget.usedMoney += price;
                    });
                  } else {
                    //벌었으니까 잔여금액 늘리기
                    financeDocRef
                        .update({'leftMoney': FieldValue.increment(price)});
                    setState(() {
                      widget.leftMoney += price;
                    });
                  }
                });
              });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 180, color: Colors.white),
            const SizedBox(height: 20),
            FinanceSpendHistory(
              usedMoney: widget.usedMoney,
              leftMoney: widget.leftMoney,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () => setState(() => isLatestOrder = true),
                  child: const Text("최신순"),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () => setState(() => isLatestOrder = false),
                  child: const Text("금액순"),
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => setState(() => showMonth -= 1),
                  child: const Icon(Icons.arrow_back_ios),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => setState(() => showMonth += 1),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: (isLatestOrder)
                  ? userColRef.orderBy('date', descending: true).snapshots()
                  : userColRef.orderBy('amountSum', descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                var myData = snapshot.data;
                List financeList = myData.docs;

                financeList = financeList.where((e) =>
                ((DateTime(DateTime.now().year, showMonth, 1).isBefore(e['date'].toDate()))
                    && ( DateTime(DateTime.now().year, showMonth + 1, 1)).isAfter(e['date'].toDate()))).toList();
                debugPrint(DateTime(DateTime.now().year, showMonth, 1).toString());
                debugPrint(financeList.length.toString());

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: financeList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var financeToday = financeList[index];
                    List items = financeToday['data'];
                    items.sort(
                        (a, b) => a['price'].abs().compareTo(b['price'].abs()));

                    return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    DateFormat('M.dd')
                                        .format(financeToday['date'].toDate()),
                                    style: const TextStyle(fontSize: 30)),
                                Text(myFormat.format(financeToday['amountSum']),
                                    style: TextStyle(
                                        color: (financeToday['amountSum'] >= 0)
                                            ? Colors.blue
                                            : Colors.red,
                                        fontSize: 25)),
                              ],
                            ),
                            const Divider(
                              color: Colors.blueGrey,
                              thickness: 1,
                            ),
                            Table(
                                columnWidths: const {0: FixedColumnWidth(70)},
                                children: List.generate(items.length, (index) {
                                  var item = items[items.length - 1 - index];

                                  return TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                          (item['price'] > 0)
                                              ? '+${myFormat.format(item['price'])}'
                                              : myFormat.format(item['price']),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: (item['price'] >= 0)
                                                  ? Colors.blue
                                                  : Colors.red)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(item['place'],
                                          style: const TextStyle(fontSize: 18)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(item['item'],
                                          style: const TextStyle(fontSize: 18)),
                                    )
                                  ]);
                                })),
                          ],
                        ));
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
