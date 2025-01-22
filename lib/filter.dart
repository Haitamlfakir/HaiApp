import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterFiretore extends StatefulWidget {
  const FilterFiretore({super.key});

  @override
  State<FilterFiretore> createState() => _FilterFiretoreState();
}

class _FilterFiretoreState extends State<FilterFiretore> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Container(
          child: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(snapshot.data!.docs[index].id);

                    FirebaseFirestore.instance
                        .runTransaction((Transaction) async {
                      DocumentSnapshot snapshot =
                          await Transaction.get(documentReference);
                      if (snapshot.exists) {
                        var snapshotData = snapshot.data();

                        if (snapshotData is Map<String, dynamic>) {
                          int money = snapshotData['money'] + 100;

                          Transaction.update(documentReference, {
                            "money": money,
                          });
                        }
                      }
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text("${snapshot.data!.docs[index]["username"]}"),
                      subtitle: Text("${snapshot.data!.docs[index]["age"]}"),
                      trailing: Text(
                        "${snapshot.data!.docs[index]["money"]}\$",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              });
        },
        stream: usersStream,
      )),
    );
  }
}
