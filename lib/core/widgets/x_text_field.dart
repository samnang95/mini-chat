import 'package:flutter/material.dart';

class XTextField extends StatelessWidget {
  const XTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(decoration: InputDecoration(border: OutlineInputBorder()));
  }
}
