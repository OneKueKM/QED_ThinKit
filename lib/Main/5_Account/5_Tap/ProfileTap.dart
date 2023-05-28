import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:qed_app_thinkit/Main/5_Account/5_Tap/InfoSecurity.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; //Haptic Feedback

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileTap extends StatefulWidget {
  DocumentSnapshot<Map<String, dynamic>> userInfo;

  ProfileTap({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ProfileTap> createState() => _ProfileTapState();
}

/* 여기서 왜 따로 firebase User doc을 따로 불러오지 않고
 따로 map을 따로 불러오는 방식으로 한 이유는 Stream을 만들어서 코드가 복잡해지는 현상을
 막기 위함임을 밝힙니다. */

class _ProfileTapState extends State<ProfileTap> {
  bool editProfile = false;

  Map<String, dynamic>? userInfo;
  TextEditingController? _nameController;
  TextEditingController? _idController;
  TextEditingController? _explainController;
  TextEditingController? _telnumController;
  TextEditingController? _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ImageProvider myImage;
  final User? me = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userInfo = widget.userInfo.data();
    _nameController = TextEditingController(text: userInfo!['userName']);
    _idController = TextEditingController(text: userInfo!['userID']);
    _explainController = TextEditingController(text: userInfo!['userExplain']);
    _telnumController = TextEditingController(text: userInfo!['telephoneNum']);
    _emailController = TextEditingController(text: userInfo!['email']);
    debugPrint(userInfo!['userProfile']);
    myImage = NetworkImage(userInfo!['userProfile']);
  }

  Future<bool> isSomeoneisUsingID(String value) async {
    if (userInfo!['userID'] != value) {
      //ID 값을 바꿀 거면
      var query = (await FirebaseFirestore.instance
          .collection('Users')
          .where('userID', isEqualTo: value)
          .limit(3)
          .get());
      debugPrint("Query: ${query.toString()}");
      debugPrint("Query num: ${query.size}");
      return (query.size != 0);
    } else {
      //바뀌지 않았으면
      return false;
    }
  }

  Future<File?> _cropImage(File pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    return (croppedFile != null) ? File(croppedFile.path) : null;
  }

  void uploadImage(ImageSource imageSource) async {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(me!.uid);
    File pickedImage;
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: imageSource,
      imageQuality: 50,
    );
    if (imageFile != null) {
      pickedImage = File(imageFile.path);
      var croppedImage = await _cropImage(pickedImage);
      setState(() => myImage = FileImage(croppedImage!));
      var toSaveRef = FirebaseStorage.instance
          .ref()
          .child('profile')
          .child('${widget.userInfo.id}.png');
      await toSaveRef.putFile(croppedImage!);
      var url = await toSaveRef.getDownloadURL();
      userDoc.update({'userProfile': url});
    }
  }

  void changeToBasicImage() async {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(me!.uid);
    var toSaveRef =
        FirebaseStorage.instance.ref().child('profile').child('default.jpeg');
    var url = await toSaveRef.getDownloadURL();
    setState(() => myImage = NetworkImage(url));
    userDoc.update({'userProfile': url});
  }

  @override
  Widget build(BuildContext context) {
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(me!.uid);

    if (editProfile) {
      return Scaffold(
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 350,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(userInfo!['userProfile']))),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 222, 222),
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              const InfoSecurity());
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(TablerIcons.shield, size: 22),
                                        Text('  정보 공개 설정',
                                            style: TextStyle(
                                                fontFamily: 'SFProText',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    child: GestureDetector(
                                  onTap: () async {
                                    editProfile = false;
                                    if (_formKey.currentState!.validate()) {
                                      if (await isSomeoneisUsingID(
                                          _idController!.text)) {
                                        Get.snackbar('ID를 다시 입력하세요!',
                                            '누군가가 같은 ID를 이미 사용 중입니다.');
                                        return;
                                      } //아이디 중복 확인 필터 나중에 필요
                                      else {
                                        userDoc.update({
                                          'userName': _nameController!.text,
                                          'userID': _idController!.text,
                                          'userExplain':
                                              _explainController!.text,
                                          'telephoneNum':
                                              _telnumController!.text,
                                          'email': _emailController!.text,
                                        });
                                        me!.updateEmail(_emailController!
                                            .text); //이것으로도 메일이 바뀌지 않을 수 있음.
                                        if (!mounted) return;
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    height: 25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('Done',
                                            style: TextStyle(
                                                fontFamily: 'SFProText',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14))
                                      ],
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(children: const [
                            Text("  이름",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 233, 233, 233))),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 233, 233, 233),
                                  hintText: 'your name',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SFPro',
                                      color: Colors.grey),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Your Name';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 14),
                          Row(children: const [
                            Text('  User ID',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: _idController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 233, 233, 233))),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 233, 233, 233),
                                  hintText: 'ID',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SFPro',
                                      color: Colors.grey),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Your ID';
                                  }

                                  return null;
                                }),
                          ),
                          const SizedBox(height: 14),
                          Row(children: const [
                            Text('  한 줄 소개',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: _explainController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11)),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 233, 233, 233))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 233, 233, 233),
                                hintText: 'ID',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'SFPro',
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(children: const [
                            Text('  전화번호',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: _telnumController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11)),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 233, 233, 233))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 233, 233, 233),
                                hintText: 'ID',
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'SFPro',
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(children: const [
                            Text('  이메일',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 233, 233, 233))),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 233, 233, 233),
                                  hintText: 'ID',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SFPro',
                                      color: Colors.grey),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Your Email';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 14),
                          Row(children: const [
                            Text('  소셜 서비스',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            child: TextFormField(
                                textAlignVertical: TextAlignVertical.bottom,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    TablerIcons.brand_instagram,
                                    color: Color.fromARGB(255, 247, 113, 158),
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 233, 233, 233))),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 233, 233, 233),
                                  hintText: 'SNS 연동',
                                  hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SFPro',
                                      color: Colors.grey),
                                )),
                          ),
                          const SizedBox(height: 14),
                          Row(children: [
                            Text('  ${userInfo!['userName']} 소개',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.w600))
                          ]),
                          const SizedBox(height: 7),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 233, 233, 233),
                                borderRadius: BorderRadius.circular(22)),
                            height: 300,
                            child: TextFormField(
                                textAlignVertical: TextAlignVertical.top,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 233, 233, 233))),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 233, 233, 233),
                                  hintText: ' 😎  나의 소개로 피드를 꾸며보세요!',
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SFPro',
                                      color: Colors.grey),
                                )),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      );
    }

    return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(children: [
                Form(
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(userInfo!['userProfile']))),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 4,
                        width: 40,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 222, 222, 222),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: GestureDetector(
                                      onTap: () => showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoActionSheet(
                                                title: const Text("프로필 사진 설정"),
                                                actions: [
                                                  CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        uploadImage(ImageSource
                                                            .gallery);
                                                        setState(() =>
                                                            NetworkImage(userInfo![
                                                                'userProfile']));
                                                      },
                                                      child: const Text(
                                                          "엘범에서 사진 선택")),
                                                  CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        uploadImage(
                                                            ImageSource.camera);
                                                      },
                                                      child: const Text(
                                                          "카메라로 찍어서 선택")),
                                                  CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        changeToBasicImage();
                                                        setState(() => myImage =
                                                            NetworkImage(userInfo![
                                                                'userProfile']));
                                                      },
                                                      child: const Text(
                                                          "기본 이미지 선택")),
                                                ],
                                              )),
                                      child: Row(
                                        children: const [
                                          Icon(TablerIcons.photo, size: 22),
                                          Text('  프로필 사진 설정',
                                              style: TextStyle(
                                                  fontFamily: 'SFProText',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: GestureDetector(
                                        onTap: () =>
                                            setState(() => editProfile = true),
                                        child: const Icon(
                                            TablerIcons.writing_sign,
                                            size: 25)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    TablerIcons.phone,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                  const VerticalDivider(
                                    color: Colors.black,
                                    width: 7,
                                    thickness: 1.5,
                                    indent: 9,
                                    endIndent: 9,
                                  ),
                                  const Icon(
                                    TablerIcons.mail_opened,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const VerticalDivider(
                                    color: Colors.black,
                                    width: 7,
                                    thickness: 1.5,
                                    indent: 9,
                                    endIndent: 9,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          'https://www.instagram.com/kminforgood/'));
                                    },
                                    child: const Icon(
                                        TablerIcons.brand_instagram,
                                        size: 22),
                                  ),
                                  const VerticalDivider(
                                    color: Colors.black,
                                    width: 7,
                                    thickness: 1.5,
                                    indent: 9,
                                    endIndent: 9,
                                  ),
                                  const Icon(TablerIcons.brand_telegram,
                                      size: 22)
                                ],
                              ),
                            ),
                            const Divider(
                                height: 30,
                                color: Color.fromARGB(255, 188, 188, 188),
                                thickness: 1),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  '이름',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15),
                                Text(
                                  userInfo!['userName'],
                                  style: const TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  '한 줄 소개',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15),
                                Text(
                                  userInfo!['userExplain'],
                                  style: const TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Read Me !',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
