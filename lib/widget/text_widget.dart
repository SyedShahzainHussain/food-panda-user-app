import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  const TextWidget({
    super.key,
    this.hint,
    this.textEditingController,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: textEditingController,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value!.isEmpty ? "Field can not be empty" : null,
      ),
    );
  }
}
