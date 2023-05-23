import 'package:flutter/material.dart';

class MinorRoomBox extends StatelessWidget {
  String upText;
  String? downText;
  Color minorRoomBoxColor;
  void Function()? ontap;
  void Function()? onLongPress;

  MinorRoomBox(
      {Key? key,
      required this.upText,
      this.downText,
      required this.minorRoomBoxColor,
      this.ontap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: minorRoomBoxColor, width: 1.5),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: minorRoomBoxColor, blurRadius: 2)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(upText,
                      style: const TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                ],
              )),
        ],
      ),
    );
  }
}
