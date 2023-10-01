import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final String id;
  final String title;
  final DateTime startedTime;
  final int speed;
  final Function onDelete;
  final Function onUpdate;

  Item(this.id, this.title, this.startedTime, this.speed, this.onDelete, this.onUpdate);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'startedTime': startedTime.toIso8601String(),
    'speed': speed,
  };

  static Item fromJson(Map<String, dynamic> json) => Item(
    json['id'],
    json['title'],
    DateTime.parse(json['startedTime']),
    json['speed'],
    () => {},
    () => {},
  );

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late DateTime now;
  Timer? _timer;

  final TextEditingController _textEditingController = TextEditingController();


  @override
  void initState() {
    now = DateTime.now();

    _timer =
        Timer.periodic(Duration(milliseconds: 1000 ~/ widget.speed), (Timer t) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showEditDialog(BuildContext context, String title) {
    _textEditingController.text = title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('제목 수정'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: '제목을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                widget.onUpdate(_textEditingController.text);
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(widget.title),
            subtitle: (BuildContext context) {
              int milliPassed = now.millisecondsSinceEpoch - widget.startedTime.millisecondsSinceEpoch;
              int ifTimePassed = milliPassed * widget.speed;

              DateTime ifNow = DateTime.fromMillisecondsSinceEpoch(
                  widget.startedTime.millisecondsSinceEpoch + ifTimePassed);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mm:ss').format(ifNow),
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              );
            }(context),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('수정'),
                          onTap: () {
                            Navigator.pop(context); // Close the modal
                            _showEditDialog(context, widget.title); // Show the edit dialog
                            // Add your edit logic here
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('삭제'),
                          onTap: () {
                            Navigator.pop(context); // Close the modal
                            widget.onDelete();
                          },
                        ),
                      ],
                    );
                  }
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Text("x${widget.speed}"),
        )
      ],
    );
  }
}
