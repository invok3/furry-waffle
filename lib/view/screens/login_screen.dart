import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app/controller/firebase_auth.dart';
import 'package:task_app/view/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obsPwd = true;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                FormInput(
                  vFun: (value) => value.isEmpty ||
                          !(value.contains("@") && value.contains("."))
                      ? "invalid Email Address"
                      : null,
                  hText: 'Email Address',
                  kbType: TextInputType.emailAddress,
                  pIcon: Icon(Icons.email_outlined),
                  tecontroller: email,
                ),
                FormInput(
                  hText: "Password",
                  pIcon: Icon(Icons.lock_outline),
                  vFun: (value) =>
                      value.length < 6 ? "Password is Too Short" : null,

                  // vFun: (value) {
                  //   validatePassword(value);
                  // },
                  kbType: TextInputType.text,
                  sIcon: IconButton(
                    onPressed: () {
                      toggleObs();
                    },
                    icon: Icon(Icons.remove_red_eye_outlined),
                  ),
                  obsd: obsPwd, tecontroller: password,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FBAuthService(FirebaseAuth.instance).signIn(
                                email: email.text, password: password.text);
                          }
                        },
                        child: Text("Login")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text("Register"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleObs() {
    obsPwd = !obsPwd;
    setState(() {});
  }
}

class FormInput extends StatelessWidget {
  final String hText;
  final Icon pIcon;
  final sIcon;
  final vFun;
  final TextEditingController tecontroller;
  final TextInputType kbType;
  final bool obsd;
  const FormInput({
    Key? key,
    required this.hText,
    required this.pIcon,
    this.sIcon,
    required this.vFun,
    required this.kbType,
    this.obsd = false,
    required this.tecontroller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hText,
        prefixIcon: pIcon,
        suffixIcon: sIcon,
      ),
      controller: tecontroller,
      validator: vFun,
      keyboardType: kbType,
      obscureText: obsd,
    );
  }
}
