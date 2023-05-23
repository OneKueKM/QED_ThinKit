import 'package:flutter/material.dart';

class MajorRoomBox extends StatelessWidget {
  String upText;
  String downText;
  Color majorRoomBoxColor;
  bool favorites;
  void Function()? ontap;

  MajorRoomBox(
      {Key? key,
      required this.upText,
      required this.downText,
      required this.majorRoomBoxColor,
      this.favorites = false,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              height: 77,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: majorRoomBoxColor.withOpacity(0.7), width: 0.5),
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: majorRoomBoxColor.withOpacity(0.3),
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 2,
                    )
                  ]),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 220,
                      child: Text(upText,
                          style: const TextStyle(
                              fontFamily: 'SFProDisplay',
                              fontSize: 19,
                              fontWeight: FontWeight.w400)),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          favorites
                              ? Icon(
                            Icons.star,
                            color: Colors.grey,
                          )
                              : Container(),
                          Text(
                            downText,
                            style: const TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontSize: 10,
                                color: Color.fromARGB(255, 122, 122, 122),
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 2)
                        ],
                      ),
                    )
                  ])),
        ],
      ),
    );
  }
}
