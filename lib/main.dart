import 'package:flutter/material.dart';
import 'package:if_timer/StorageService.dart';

import 'components/CreateTimer.dart';
import 'components/TimerList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorageService().init();

  runApp(const IfTimerApp());
}

class IfTimerApp extends StatefulWidget {
  const IfTimerApp({super.key});

  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<IfTimerApp> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const TimerList(),
    const CreateTimer(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "If Timer Title",
      home: Scaffold(
        appBar: AppBar(title: const Text('IF Timer')),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
