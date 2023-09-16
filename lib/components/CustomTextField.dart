import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: '속도',
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
            return '시간의 속도를 입력하세요';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
