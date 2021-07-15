import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreServices {
  //add document to useres with uid -- someone registered
  final FirebaseFirestore fbFireStore;
  Future<void> addUser(
      String uid, String email, String imgurl, String name) async {
    return fbFireStore
        .collection("users")
        .doc(uid)
        .set({'email': email, 'imageurl': imgurl, "name": name})
        .then((value) => print("Sccess added"))
        .onError((error, stackTrace) => print(error.toString()));
  }

  //from users where uid set imgurl //updated igame url
  Future<void> updateProfileImage(String imgurl, String uid) {
    return fbFireStore
        .collection("users")
        .doc(uid)
        .update({"imageurl": imgurl})
        .then((value) => null)
        .onError((error, stackTrace) => null);
  }

  //maybe as snapchat. delete after read so dispose if refreshed!!!!

  FirebaseFirestoreServices(this.fbFireStore);
}
