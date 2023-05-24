import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  String userName;
  String userExplain;
  String userProfileURL;
  int userConnectedNum;
  void Function()? ontap;

  ProfileCard(
      {Key? key,
      required this.userName,
      required this.userExplain,
      required this.userProfileURL,
      required this.userConnectedNum,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(182, 208, 208, 208),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Hero(
                          tag: 'ProfileImage',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(userProfileURL))),
                            ),
                          )),
                      const SizedBox(width: 15),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 5),
                                Text(userExplain,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'SFProDisplay',
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$userConnectedNum',
                                style: const TextStyle(
                                    fontSize: 19,
                                    color: Color.fromARGB(255, 1, 165, 29),
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w500)),
                            const Text('연결됨',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontFamily: 'SFProDisplay',
                                    color: Color.fromARGB(255, 1, 165, 29),
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
