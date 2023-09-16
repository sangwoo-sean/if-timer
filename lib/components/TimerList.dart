import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CustomTextField.dart';

class TimerList extends StatefulWidget {
  const TimerList({super.key});

  @override
  State<StatefulWidget> createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  final List<String> items = List<String>.generate(10, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            // Action when tapping on an item
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You tapped on ${items[index]}'),
              ),
            );
          },
        );
      },
    );
  }
}