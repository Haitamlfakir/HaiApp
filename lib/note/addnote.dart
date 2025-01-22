import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/compenents/fieldadd.dart';
import 'package:haiapp/note/view.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> add = GlobalKey();

  TextEditingController note = TextEditingController();

  bool isloading = false;

  addNote() async {
    CollectionReference collnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("note");
    if (add.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await collnote.add({"note": note.text});
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NoteView(categoryid: widget.docid)));
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error : $e");
      }
    }
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
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
                              hinttext: "Enter a Note",
                              control: note,
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
                                addNote();
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
