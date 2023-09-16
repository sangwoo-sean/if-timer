import 'package:flutter/material.dart';

import 'Item.dart';

class TimerList extends StatefulWidget {
  const TimerList({super.key});

  @override
  State<StatefulWidget> createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  final List<Item> items = List<Item>.generate(
          3, (index) => Item("Title $index", DateTime(2023, 9, 16), index + 1))
      .toList();
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: index == items.length - 1
                    ? null
                    : const Border(bottom: BorderSide(color: Colors.grey))),
            child: items[index],
          ),
        );
      },
    );
  }
}
