import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController control;
  final String? Function(String?)? validator;

  const TextForm({super.key, required this.hinttext, required this.control, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        validator: validator,
        controller: control,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            hintText: "$hinttext",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
