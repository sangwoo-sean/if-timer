import 'dart:async';

import 'package:flutter/material.dart';
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
  bool _isRunning = false;
  DateTime startTime = DateTime.now();
  var speed = 1;
  final TextEditingController _textController = TextEditingController();

  void _startTimer() {
    if (!_isRunning && _textController.text.isNotEmpty) {
      setState(() {
        _isRunning = true;
        startTime = DateTime.now();
        speed = int.parse(_textController.text);
      });
      _ifTimer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        setState(() {
          _timePassed = _timePassed + speed;
        });
      });
    }
  }

  void _pauseTimer() {
    if (_ifTimer != null && _isRunning) {
      _ifTimer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    if (_ifTimer != null) {
      _ifTimer!.cancel();
      setState(() {
        _isRunning = false;
        _timePassed = 0;
        startTime = DateTime.now();
      });
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
                onPressed: _startTimer, child: const Text('Start')),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: _pauseTimer, child: const Text('Pause')),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: _resetTimer, child: const Text('Reset')),
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