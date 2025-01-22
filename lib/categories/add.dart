import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/compenents/fieldadd.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  GlobalKey<FormState> add = GlobalKey();

  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isloading = false;

  addCategory() async {
    if (add.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference response = await categories.add({"name": name.text , "id" : FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Form(
                    key: add,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Fieldadd(
                              hinttext: "Enter name",
                              control: name,
                              validator: (val) {
                                if (val == "") {
                                  return "Cant be Empty";
                                }
                                return null;
                              }),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: Colors.purple[900],
                            ),
                            child: MaterialButton(
                              textColor: Colors.white,
                              onPressed: () {
                                addCategory();
                              },
                              child: Text("Add"),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
    );
  }
}
