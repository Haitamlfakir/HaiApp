import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haiapp/compenents/fieldadd.dart';
import 'package:haiapp/note/view.dart';

class EditNote extends StatefulWidget {
  final String catdocid;
  final String notdocid;
  final String oldnote;
  const EditNote(
      {super.key,
      required this.notdocid,
      required this.catdocid,
      required this.oldnote});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> edit = GlobalKey();

  TextEditingController note = TextEditingController();

  bool isloading = false;

  editNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catdocid)
        .collection("note");
    if (edit.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await collectionnote.doc(widget.notdocid).update({"note": note.text});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(categoryid: widget.catdocid)));
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error : $e");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.oldnote;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
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
                    key: edit,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Fieldadd(
                              hinttext: "Enter name",
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
                                editNote();
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
