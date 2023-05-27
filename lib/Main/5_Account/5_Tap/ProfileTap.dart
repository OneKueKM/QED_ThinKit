import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool EditProfile = false;

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
      maxHeight: 600,
      maxWidth: 600,
      imageQuality: 100,
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
                                    onTap: () => showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoActionSheet(
                                              title: const Text("프로필 사진 설정"),
                                              actions: [
                                                CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      uploadImage(
                                                          ImageSource.gallery);
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
                                                    },
                                                    child: const Text(
                                                        "기본 이미지 선택")),
                                              ],
                                            )),
                                    child: const Icon(TablerIcons.photo,
                                        size: 25)),
                              ),
                              SizedBox(
                                child: GestureDetector(
                                    onTap: () =>
                                        setState(() => EditProfile = true),
                                    child: const Icon(TablerIcons.writing_sign,
                                        size: 25)),
                              ),
                            ],
                          ),
                        ),
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
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(userInfo!['email'])
                                      // ignore: avoid_print
                                      .then((value) => print('Copied'));
                                },
                                child: const Icon(TablerIcons.phone, size: 25),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 11,
                                endIndent: 11,
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(userInfo!['email'])
                                      // ignore: avoid_print
                                      .then((value) => print('Copied'));
                                },
                                child: const Icon(TablerIcons.mail_opened,
                                    size: 22),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 11,
                                endIndent: 11,
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      'https://www.instagram.com/kminforgood/'));
                                },
                                child: const Icon(TablerIcons.brand_instagram,
                                    size: 22),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                width: 7,
                                thickness: 1.5,
                                indent: 11,
                                endIndent: 11,
                              ),
                              const Icon(TablerIcons.brand_telegram, size: 22)
                            ],
                          ),
                        ),
                        const Divider(
                            height: 30,
                            color: Color.fromARGB(255, 188, 188, 188),
                            thickness: 1),
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 10),
                        Row(children: const [
                          Text("이름",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'SDFText',
                                  fontWeight: FontWeight.w700))
                        ]),
                        SizedBox(
                          height: 25,
                          child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
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
                        const SizedBox(height: 5),
                        Row(children: const [
                          Text('user ID',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'SDFText',
                                  fontWeight: FontWeight.w700))
                        ]),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                              controller: _idController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
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
                        const SizedBox(height: 5),
                        Row(children: const [
                          Text('설명',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'SDFText',
                                  fontWeight: FontWeight.w700))
                        ]),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                            controller: _explainController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your Explains',
                              hintStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'SFPro',
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(children: const [
                          Text('전화번호',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'SDFText',
                                  fontWeight: FontWeight.w700))
                        ]),
                        SizedBox(
                          height: 35,
                          child: TextFormField(
                            controller: _telnumController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter Your Phone Number',
                              hintStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'SFPro',
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(children: const [
                          Text('이메일',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'SDFText',
                                  fontWeight: FontWeight.w700))
                        ]),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your Email',
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
}
