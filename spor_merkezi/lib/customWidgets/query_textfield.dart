import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QueryTextField extends StatelessWidget {
  const QueryTextField({
    required this.controller,
    required this.text,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String text, hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                //bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(text, style: const TextStyle(color: Colors.black))),
        TextField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  //topRight: Radius.circular(10),
                ),
              ),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly
            ]),
      ],
    );
  }
}
