import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const IfTimerApp());
}

class IfTimerApp extends StatefulWidget {
  const IfTimerApp({super.key});

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<IfTimerApp> {
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
      _ifTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        setState(() {
          _timePassed = _timePassed + speed * 1000;
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
    DateTime ifNow = DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch + _timePassed);
    String formattedIfNow = DateFormat('yyyy-MM-dd hh:mm:ss').format(ifNow);

    // var time = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('IF Timer')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(formattedIfNow, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: _startTimer, child: const Text('Start')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: _pauseTimer, child: const Text('Pause')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: _resetTimer, child: const Text('Reset')),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'Enter Speed x ?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}