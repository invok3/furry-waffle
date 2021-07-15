import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FireBaseStorageService {
  final FirebaseStorage fbStorage;
  Future uploadImage(
      {required PickedFile image,
      required String path,
      required String uid}) async {
    try {
      await fbStorage.ref().child(uid + path).putFile(File(image.path));
    } catch (ex) {
      print("FindThisEx" + ex.toString());
    }
  }

  Future<String> getpImage(String uid) async {
    // "gs://task-app-3e73a.appspot.com/QorRPtOyIRMi9xQET5MttISUgBH3/profilePicture"
    try {
      String aa = await fbStorage.ref(uid + "/profilePicture").getDownloadURL();
      return aa;
    } on FirebaseException catch (e) {
      print("Error:${e.message}");
      return "https://firebasestorage.googleapis.com/v0/b/task-app-3e73a.appspot.com/o/placeholderpng.png?alt=media&token=7e579c54-d8a5-41a0-b699-ded6da64560a";
    }
  }

  FireBaseStorageService(this.fbStorage);
}
