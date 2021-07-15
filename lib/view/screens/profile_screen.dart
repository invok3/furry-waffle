import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app/controller/firebase_auth.dart';
import 'package:task_app/controller/firebase_firestore.dart';
import 'package:task_app/controller/firebase_storage.dart';

import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User cUser = FirebaseAuth.instance.currentUser!;
  late Future<String> _pimage;

  @override
  void initState() {
    super.initState();
    _pimage =
        FireBaseStorageService(FirebaseStorage.instance).getpImage(cUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (item) => mPager(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(value: 0, child: Text("Profile")),
                    PopupMenuItem<int>(value: 1, child: Text("Channels")),
                    PopupMenuItem<int>(value: 2, child: Text("Logout")),
                  ]),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              FutureBuilder<String>(
                  future: _pimage,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        final urlimage = snapshot.data!;
                        FirebaseFirestoreServices(FirebaseFirestore.instance)
                            .updateProfileImage(urlimage, cUser.uid);
                        return CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 6,
                          backgroundImage: NetworkImage(urlimage),
                          //   backgroundImage: NetworkImage(
                          //       "https://firebasestorage.googleapis.com/v0/b/task-app-3e73a.appspot.com/o/QorRPtOyIRMi9xQET5MttISUgBH3%2FprofilePicture?alt=media&token=aa06fd2f-42f9-450f-b988-214d7d939166"),
                        );
                      default:
                        return CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 6,
                        );
                    }
                  }),
              Container(
                height: MediaQuery.of(context).size.width / 6,
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            MediaQuery.of(context).size.width / 2),
                        bottomRight: Radius.circular(
                            MediaQuery.of(context).size.width / 2))),
                child: IconButton(
                    onPressed: () => showPicker(context),
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 12,
                    )),
              ),
            ]),
          ),
          Center(
            child: Text(cUser.email!),
          )
        ],
      ),
    );
  }

  mPager(BuildContext context, item) {
    switch (item) {
      case 0:
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      default:
        FBAuthService(FirebaseAuth.instance).signOut();
        Navigator.pop(context);
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext _buildContext) => SafeArea(
                child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt_outlined),
                    title: Text("Camera"),
                    onTap: () => _imageFromCamera(),
                  ),
                  ListTile(
                    leading: Icon(Icons.image_outlined),
                    title: Text("Gallery"),
                    onTap: () => _imageFromGallery(),
                  ),
                ],
              ),
            )));
  }

  _imageFromGallery() async {
    Navigator.pop(context);
    final _img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (_img != null) {
      FireBaseStorageService(FirebaseStorage.instance)
          .uploadImage(image: _img, path: "/profilePicture", uid: cUser.uid)
          .then((value) => setState(() {
                _pimage = FireBaseStorageService(FirebaseStorage.instance)
                    .getpImage(cUser.uid);
              }));
    }
  }

  _imageFromCamera() async {
    Navigator.pop(context);
    final _img = await ImagePicker().getImage(source: ImageSource.camera);
    if (_img != null) {
      FireBaseStorageService(FirebaseStorage.instance)
          .uploadImage(image: _img, path: "/profilePicture", uid: cUser.uid)
          .then((value) => setState(() {
                _pimage = FireBaseStorageService(FirebaseStorage.instance)
                    .getpImage(cUser.uid);
              }));
    }
  }
}
