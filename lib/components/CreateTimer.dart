import 'package:flutter/material.dart';
import 'package:if_timer/StorageService.dart';
import 'package:if_timer/components/Item.dart';
import 'package:uuid/uuid.dart';
import 'CustomTextField.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();

  void _addTimer(BuildContext context) async {
    if (_speedController.text.isNotEmpty && _titleController.text.isNotEmpty) {
      Item item = Item(
          const Uuid().v4(),
          _titleController.text,
          DateTime.now(),
          int.parse(_speedController.text),
          () => {});
      await HiveStorageService().saveTimers(item);
      _titleController.text = "";
      _speedController.text = "";

      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('리스트에 추가되었습니다'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _addTimer(context);
                }, child: const Text('추가')),
          ]),
        ],
      ),
    );
  }
}
