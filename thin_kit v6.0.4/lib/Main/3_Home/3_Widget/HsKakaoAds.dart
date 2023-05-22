import 'package:flutter/material.dart';

class HsKakaoAds extends StatefulWidget {
  const HsKakaoAds({super.key});

  @override
  State<HsKakaoAds> createState() => _HsKakaoAdsState();
}

class _HsKakaoAdsState extends State<HsKakaoAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/hskakao.jpg'),
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
