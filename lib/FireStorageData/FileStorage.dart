import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FileStorage extends GetxController {
  static final FileStorage _instance = FileStorage._internal();
  factory FileStorage() => _instance; //Singleton

  late FirebaseStorage storage;
  late Reference storageRef;

  FileStorage._internal() {
    storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile(String filepath, String uploadPath) async {
    File file = File(filepath);

    try{
      storageRef = storage.ref(uploadPath); //저장소 주소 storageRef에 저장
      await storageRef.putFile(file); //저장소에 파일 저장
      String downloadURL = await storageRef.getDownloadURL(); //저장소 url
      return downloadURL; //저장소 url
    } on FirebaseException catch (e){
      return '-1';
    }
  }

}