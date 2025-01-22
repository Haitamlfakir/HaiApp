import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class prov extends StatefulWidget {
  const prov({super.key});

  @override
  State<prov> createState() => _provState();
}

class _provState extends State<prov> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("State Management With Provider"),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) {
              return Model();
            }),
            ChangeNotifierProvider(create: (context) {
              return Name();
            }),
          ],
          child: Column(
            children: [
              Container(
                  child: Consumer<Model>(builder: (context, model, child) {
                return Text(model.showsomething);
              })),
              Container(child: Consumer<Name>(builder: (context, name, child) {
                return Text(name.name);
              })),
              Container(
                  child: Consumer<Model>(builder: (context, model, child) {
                return MaterialButton(
                  onPressed: () {
                    model.dosomething1();
                  },
                  child: Text("do something one"), 
                );
              })),
              Container(child: Consumer<Name>(builder: (context, name, child) {
                return MaterialButton(
                  onPressed: () {
                    name.changeName();
                  },
                  child: Text("do something two"),
                );
              }))
            ],
          ),
        ));
  }
}

class Model with ChangeNotifier {
  var showsomething = "ShowSomething";
  dosomething1() {
    showsomething = "Provider Yes One";
    notifyListeners();
  }

  dosomething2() {
    showsomething = "Provider Yes Two";
    notifyListeners();
  }
}

class Name with ChangeNotifier {
  var name = "omar";
  changeName() {
    name = "haitam";
    notifyListeners();
  }
}
