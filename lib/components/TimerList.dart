import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:if_timer/StorageService.dart';

import 'Item.dart';

class TimerList extends StatefulWidget {
  const TimerList({super.key});

  @override
  State<StatefulWidget> createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  List<Item> items = List<Item>.empty();
  final DateTime now = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint("load...");
    loadData();
  }

  void loadData() async {
    var timersJson = await HiveStorageService().find("timers");
    List<dynamic> timers = jsonDecode(timersJson!);
    setState(() {
      items = timers.map((i) => Item.fromJson(i)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
