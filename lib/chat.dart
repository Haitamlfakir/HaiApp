import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String title;
  final String body;
  const Chat({super.key, required this.title, required this.body});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Text(widget.body)
      ),
    );
  }
}
