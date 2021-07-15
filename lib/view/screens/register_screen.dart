// import 'package:chat/controller/firebase_services.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app/controller/firebase_auth.dart';
import 'package:task_app/controller/firebase_firestore.dart';
import 'package:task_app/controller/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usr = TextEditingController();
  final email = TextEditingController();
  final pwd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _image;
  @override
  void dispose() {
    usr.dispose();
    email.dispose();
    pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                  CircleAvatar(
                    backgroundImage:
                        _image != null ? FileImage(File(_image!.path)) : null,
                    radius: MediaQuery.of(context).size.width / 6,
                  ),
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
                InputField(
                  lblText: "Nickname: ",
                  tecontroller: usr,
                  vFun: (value) =>
                      value.length < 4 ? "Nickname is Too Short" : null,
                ),
                InputField(
                  tecontroller: email,
                  lblText: "Email Address",
                  vFun: (value) => value.isEmpty ||
                          !(value.contains("@") && value.contains("."))
                      ? "invalid Email Address"
                      : null,
                ),
                InputField(
                  lblText: "Password: ",
                  tecontroller: pwd,
                  vFun: (value) =>
                      value.length < 6 ? "Password is Too Short" : null,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FBAuthService(FirebaseAuth.instance)
                          .signUp(
                              email: email.text,
                              password: pwd.text,
                              name: usr.text)
                          .then((value) async {
                        var cUser = FirebaseAuth.instance.currentUser;
                        if (value == null) {
                          //upload image
                          FirebaseFirestoreServices(FirebaseFirestore.instance)
                              .addUser(
                                  cUser!.uid, email.text, "imgurl", usr.text);
                          if (_image != null) {
                            FireBaseStorageService(FirebaseStorage.instance)
                                .uploadImage(
                                    image: _image,
                                    path: "profilePicture",
                                    uid: "${cUser.uid}/")
                                .then((value) => FireBaseStorageService(
                                        FirebaseStorage.instance)
                                    .getpImage(cUser.uid)
                                    .then((value) => FirebaseFirestoreServices(
                                            FirebaseFirestore.instance)
                                        .updateProfileImage(value, cUser.uid)));
                          }
                          //db.createdoc

                          Navigator.pop(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("Error!"),
                                    content: Text(value.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(_).pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  ));
                        }
                      });
                    }
                  },
                  child: Text("Register"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already a Member?"))
              ],
            ),
          ),
        ),
      ),
    );
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
      _image = _img;
    }
    setState(() {});
  }

  _imageFromCamera() async {
    Navigator.pop(context);
    final _img = await ImagePicker().getImage(source: ImageSource.camera);
    if (_img != null) {
      _image = _img;
    }
    setState(() {});
  }
}

class InputField extends StatelessWidget {
  final String lblText;
  final TextEditingController tecontroller;
  final TextInputType kbType;
  final formatters;
  final vFun;

  const InputField({
    Key? key,
    required this.lblText,
    required this.tecontroller,
    this.kbType = TextInputType.text,
    this.formatters,
    this.vFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: tecontroller,
      keyboardType: kbType,
      inputFormatters: formatters,
      validator: vFun,
      decoration: InputDecoration(
        labelText: lblText,
      ),
    );
  }
}
