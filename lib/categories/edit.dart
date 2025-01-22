import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/compenents/fieldadd.dart';

class Edit extends StatefulWidget {
  final String docid;
  final String oldname;
  const Edit({super.key, required this.docid, required this.oldname});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  GlobalKey<FormState> add = GlobalKey();

  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isloading = false;

  editCategory() async {
    if (add.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await categories.doc(widget.docid).set({"name": name.text ,  "id" : FirebaseAuth.instance.currentUser!.uid});
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
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
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
                                editCategory();
                              },
                              child: Text("Save"),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
    );
  }
}
