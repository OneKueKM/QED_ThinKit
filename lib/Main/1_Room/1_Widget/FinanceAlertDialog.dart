import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinanceAlertDialog extends StatefulWidget {
  Function(int, String, String, bool, DateTime) addItem;

  FinanceAlertDialog({Key? key, required this.addItem}) : super(key: key);

  @override
  State<FinanceAlertDialog> createState() => _FinanceAlertDialogState();
}

class _FinanceAlertDialogState extends State<FinanceAlertDialog> {
  static DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dateResult = today;
  final _formKey = GlobalKey<FormState>();
  final List<bool> _isConsume = [true, false];
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
          title: const Text("오늘의 소득/소비"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  //금액
                  decoration: const InputDecoration(hintText: "금액"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _priceController,
                  validator: (value) => (value!.isEmpty) ? '금액을 입력하세요.' : null,
                ),
                TextFormField(
                  //장소
                  decoration: const InputDecoration(hintText: "장소"),
                  controller: _placeController,
                  validator: (value) => (value!.isEmpty) ? '장소를 입력하세요.' : null,
                ),
                TextFormField(
                  //항목
                  decoration: const InputDecoration(hintText: "항목"),
                  controller: _itemController,
                  validator: (value) => (value!.isEmpty) ? '항목을 입력하세요.' : null,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                    child: Text("날짜")),
                SizedBox(
                  height: 150,
                  child: CupertinoDatePicker(
                    minimumYear: today.year,
                    maximumYear: today.year,
                    minimumDate: DateTime(today.year, today.month, 1),
                      maximumDate: today,
                      initialDateTime: today,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (date) => dateResult = date),
                ),
                const SizedBox(height: 30),
                ToggleButtons(
                  onPressed: (int index) {
                    debugPrint(_isConsume.toString());
                    setState(() {
                      for (int i = 0; i < _isConsume.length; i++) {
                        _isConsume[i] = i == index;
                      }
                    });
                  },
                  isSelected: _isConsume,
                  children: const [Text("지출"), Text("수익")],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                //항목추가
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  widget.addItem(
                      int.parse(_priceController.text),
                      _placeController.text,
                      _itemController.text,
                      _isConsume[0],
                      dateResult);
                }
              },
              child: const Text("등록하기"),
            )
          ]),
    );
  }
}
