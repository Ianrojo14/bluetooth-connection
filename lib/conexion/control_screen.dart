import 'package:flutter/material.dart';
import 'package:conexion_bluetooth/conexion/ble_service.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final BLEService bleService = BLEService();

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    try {
      await bleService.connectToDevice();
    } catch (e) {
      print('Error al conectar al dispositivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control BLE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await bleService.writeCharacteristic('ON');
              },
              child: Text('Encender LED'),
            ),
            ElevatedButton(
              onPressed: () async {
                await bleService.writeCharacteristic('OFF');
              },
              child: Text('Apagar LED'),
            ),
          ],
        ),
      ),
    );
  }
}
