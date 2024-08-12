import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEService {
  final String serviceUUID = "37fc19ab-98ca-4543-a68b-d183da78acdc";
  final String characteristicUUID = "a40d0c2e-73ba-4d8b-8eef-9a0666992e56";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;
  bool _permissionsRequested = false;

  Future<void> requestPermissions() async {
    if (_permissionsRequested) {
      return; // No realizar otra solicitud de permisos si ya se solicitó anteriormente
    }
    _permissionsRequested = true;

    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      print('Permisos solicitados: $statuses');
    } catch (e) {
      print('Error al solicitar permisos: $e');
    }
  }

  Future<void> connectToDevice() async {
    await requestPermissions();

    // Empezar a escanear dispositivos BLE
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    print('Escaneando dispositivos BLE...');

    // Escuchar los resultados del escaneo
    flutterBlue.scanResults.listen((scanResults) async {
      for (ScanResult scanResult in scanResults) {
        print('Dispositivo encontrado: ${scanResult.device.name}');
        if (scanResult.device.name == 'MyESP32') {
          await flutterBlue.stopScan();
          print('Dispositivo MyESP32 encontrado, deteniendo escaneo...');
          connectedDevice = scanResult.device;
          try {
            await connectedDevice?.connect();
            print('Conectado a MyESP32');
            await discoverServices();
          } catch (e) {
            print('Error al conectar al dispositivo: $e');
          }
          break;
        }
      }
    });
  }

  Future<void> discoverServices() async {
    if (connectedDevice == null) return;
    List<BluetoothService> services = await connectedDevice!.discoverServices();
    print('Descubriendo servicios...');
    for (BluetoothService service in services) {
      if (service.uuid.toString() == serviceUUID) {
        print('Servicio encontrado: $serviceUUID');
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString() == characteristicUUID) {
            characteristic = c;
            print('Característica encontrada: $characteristicUUID');
            break;
          }
        }
      }
    }
  }

  Future<void> writeCharacteristic(String value) async {
    if (characteristic != null) {
      await characteristic!.write(value.codeUnits, withoutResponse: true);
      print('Valor escrito en la característica: $value');
    }
  }
}
