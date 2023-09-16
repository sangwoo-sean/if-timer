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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('IF Timer')),
        body: const Center(
          child: CreateTimer(),
        ),
      ),
    );
  }
}

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
