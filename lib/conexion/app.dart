import 'package:flutter/material.dart';
import 'control_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexion Bluetooth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ControlScreen(),
    );
  }
}
