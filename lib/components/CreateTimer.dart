import 'package:flutter/material.dart';
import 'package:if_timer/StorageService.dart';
import 'package:if_timer/components/Item.dart';

import 'CustomTextField.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();

  void _addTimer() async {
    if (_speedController.text.isNotEmpty && _titleController.text.isNotEmpty) {
      Item item = Item(_titleController.text, DateTime.now(),
          int.parse(_speedController.text));
      await HiveStorageService().saveTimers(item);
      _titleController.text = "";
      _speedController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        CustomTextField(
          controller: _titleController,
          label: "타이머 이름",
          invalidText: '타이머 이름을 입력하세요',
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _speedController,
          label: "속도",
          invalidText: '시간의 속도를 입력하세요',
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _addTimer, child: const Text('추가')),
          ],
        ),
      ],
    );
  }
}
