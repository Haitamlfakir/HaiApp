import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/compenents/logoauth.dart';
import 'package:haiapp/compenents/textformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Customlogo(),
                  Container(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "SignUp",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 6),
                    child: Text(
                      "SignUp to continue using the app",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 25, bottom: 5),
                    child: Text(
                      "Username",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextForm(
                    hinttext: "Add a username",
                    control: username,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 25, bottom: 5),
                    child: Text(
                      "Email",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextForm(
                    hinttext: "Type a email",
                    control: email,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 25, bottom: 5),
                    child: Text(
                      "Password",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextForm(
                    hinttext: "Add a password",
                    control: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 400,
                  ),
                  Container(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 300,
                      height: 50,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Colors.purple[700],
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            try {
                               await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              Navigator.of(context)
                                  .pushReplacementNamed("login");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: "Error",
                                  desc: "The password provided is too weak.",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    "The account already exists for that email.");
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: "Error",
                                  desc:
                                      "The account already exists for that email.",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            print("Not Valid");
                          }
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
              child: Container(
                width: 400,
                margin: const EdgeInsets.only(top: 50),
                child: const Row(
                  children: [
                    Text(
                      "                        You have an account?  ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.purple))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
