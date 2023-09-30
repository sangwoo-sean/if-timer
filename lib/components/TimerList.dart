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
    loadData();
  }

  void loadData() async {
    List<Item> timers = await HiveStorageService().findTimers();
    setState(() {
      items = timers.map((i) => Item(
        i.id,
        i.title,
        i.startedTime,
        i.speed,
        () => handleDeleteItem(i.id),
      )).toList();
      isLoading = false;
    });
  }

  void handleDeleteItem(String id) async {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
    await HiveStorageService().deleteTimer(id);
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
        return Container(
          decoration: BoxDecoration(
              border: index == items.length - 1
                  ? null
                  : const Border(bottom: BorderSide(color: Colors.grey))),
          child: items[index],
        );
      },
    );
  }
}
