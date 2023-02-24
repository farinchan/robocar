import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Bluetooth extends ChangeNotifier {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> savedDevices = <BluetoothDevice>[];

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;

  List<BluetoothDiscoveryResult> availabledevices =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  void getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
      if (bluetoothState.isEnabled) {
        listBondedDevices();
      }
      notifyListeners();
    });
  }

  void stateChangeListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;
      if (bluetoothState.isEnabled) {
        listBondedDevices();
      } else {
        savedDevices.clear();
      }
      print("State isEnabled: ${state.isEnabled}");
      notifyListeners();
    });
  }

  void listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      savedDevices = bondedDevices;
      notifyListeners();
    });
  }

  void RequestBluetoothSwitch(bool value) async {
    if (value == true) {
      await FlutterBluetoothSerial.instance.requestEnable().then((value) {
        notifyListeners();
      });
    } else {
      await FlutterBluetoothSerial.instance.requestDisable().then((value) {
        notifyListeners();
      });
    }
  }

  void _restartDiscovery() {
    savedDevices.clear();
    isDiscovering = true;
    notifyListeners();

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final existingIndex = availabledevices
          .indexWhere((element) => element.device.address == r.device.address);
      if (existingIndex >= 0)
        availabledevices[existingIndex] = r;
      else
        availabledevices.add(r);
      notifyListeners();
    });

    _streamSubscription!.onDone(() {
      isDiscovering = false;
      notifyListeners();
    });
  }
}
