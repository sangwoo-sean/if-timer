import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final String title;
  final DateTime startedTime;
  final int speed;

  Item(this.title, this.startedTime, this.speed);

  Map<String, dynamic> toJson() => {
    'title': title,
    'startedTime': startedTime.toIso8601String(),
    'speed': speed,
  };

  static Item fromJson(Map<String, dynamic> json) => Item(
    json['title'],
    DateTime.parse(json['startedTime']),
    json['speed'],
  );

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late DateTime now;
  Timer? _timer;

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
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context); // Close the modal
                            // Add your edit logic here
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context); // Close the modal
                            // Add your delete logic here
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
