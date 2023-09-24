import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String invalidText;

  const CustomTextField({required this.controller, required this.label, required this.invalidText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: MaterialStateTextStyle.resolveWith(
                (Set<MaterialState> states) {
              final Color color = states.contains(MaterialState.error)
                  ? Theme.of(context).colorScheme.error
                  : Colors.blue;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return invalidText;
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
