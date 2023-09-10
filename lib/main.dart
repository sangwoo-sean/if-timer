import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const IfTimerApp());
}

class IfTimerApp extends StatefulWidget {
  const IfTimerApp({super.key});

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<IfTimerApp> {
  int _timeInSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _timeInSeconds++;
        });
      });
    }
  }

  void _pauseTimer() {
    if (_timer != null && _isRunning) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
        _timeInSeconds = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _timeInSeconds ~/ 60;
    int seconds = _timeInSeconds % 60;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Simple Timer App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 48),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}