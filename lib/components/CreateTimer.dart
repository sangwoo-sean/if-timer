import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:if_timer/StorageService.dart';
import 'package:if_timer/components/Item.dart';
import 'package:intl/intl.dart';

import 'CustomTextField.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
  int _timePassed = 0;
  Timer? _ifTimer;
  DateTime startTime = DateTime.now();
  var speed = 1;
  final TextEditingController _textController = TextEditingController();

  void _addTimer() async {
    if (_textController.text.isNotEmpty) {
      var timersJson = await HiveStorageService().find("timers");
      if (timersJson != null) {
        List<dynamic> timers = jsonDecode(timersJson);
        List<Item> items = timers.map((i) => Item.fromJson(i)).toList();
        items.add(Item("title", DateTime.now(), int.parse(_textController.text)));
        await HiveStorageService().save("timers", jsonEncode(items));
        _textController.text = "a";
      }
    }
  }

  @override
  void dispose() {
    _ifTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime ifNow = DateTime.fromMillisecondsSinceEpoch(
        startTime.millisecondsSinceEpoch + _timePassed);
    String formattedIfNow = DateFormat('yyyy-MM-dd hh:mm:ss').format(ifNow);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(formattedIfNow, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: _addTimer, child: const Text('추가')),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _textController,
        )
      ],
    );
  }
}