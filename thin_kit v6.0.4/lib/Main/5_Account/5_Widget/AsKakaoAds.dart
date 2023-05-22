import 'package:flutter/material.dart';

class AcKakaoAds extends StatefulWidget {
  const AcKakaoAds({super.key});

  @override
  State<AcKakaoAds> createState() => _AcKakaoAdsState();
}

class _AcKakaoAdsState extends State<AcKakaoAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 165,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/ackakao.jpg'),
              fit: BoxFit.fitWidth),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
          borderRadius: BorderRadius.circular(7),
        ));
  }
}
