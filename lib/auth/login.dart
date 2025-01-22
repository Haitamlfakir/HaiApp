import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haiapp/compenents/logoauth.dart';
import 'package:haiapp/compenents/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isloading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading ? Center(child: CircularProgressIndicator(),) : Container(
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
                      "Login",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 6),
                    child: Text(
                      "Login to continue using the app",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
                    child: Text(
                      "Email",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextForm(
                    hinttext: "Type your email",
                    control: email,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 5),
                    child: Text(
                      "Password",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextForm(
                    hinttext: "Type your password",
                    control: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: "Info",
                          desc: "Go to your email box to reset the pasword",
                        ).show();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 400,
                        child: const Text("Forget Password?",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.blue))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 50, right: 50),
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
                            isloading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            isloading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.infoReverse,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc:
                                    "Please go check email box and then verify it to continue with your account",
                                btnOkOnPress: () {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                },
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            isloading = false;
                            setState(() {});
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: "No user found for that email.",
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: "Error",
                                desc: "Wrong password provided for that user.",
                              ).show();
                            }
                          }
                        } else {
                          print("Not Valid");
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "--------------------------- or login ---------------------------",
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.apple,
                        size: 60,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook,
                          size: 60, color: Colors.blue)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      icon: const Icon(
                        Icons.mail,
                        size: 60,
                        color: Colors.red,
                      )),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: Container(
                width: 400,
                margin: const EdgeInsets.only(top: 50),
                child: const Row(
                  children: [
                    Text(
                      "                   Don't have an account?  ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Register",
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
