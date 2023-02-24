import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:robocar_orbit/provider/bluetooth.dart';
import 'package:robocar_orbit/widget/bluetooth_scan_widget.dart';

class BluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robocar Bluetooth"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SwitchListTile(
            title: Text('Enable Bluetooth'),
            value: Provider.of<Bluetooth>(context).bluetoothState.isEnabled,
            onChanged: (bool value) async {
              Provider.of<Bluetooth>(context, listen: false)
                  .RequestBluetoothSwitch(value);
            },
          ),
          ListTile(
            title: Text("Bluetooth STATUS"),
            subtitle:
                Text(Provider.of<Bluetooth>(context).bluetoothState.toString()),
            trailing: ElevatedButton(
              child: Text("Settings"),
              onPressed: () {
                FlutterBluetoothSerial.instance.openSettings();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Perangkat Yang Tersimpan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            children: Provider.of<Bluetooth>(context)
                .savedDevices
                .map((_device) => BluetoothDeviceListEntry(
                      device: _device,
                      enabled: true,
                      onTap: () async {
                        print("Item");
                        try {
                          BluetoothConnection connection =
                              await BluetoothConnection.toAddress(
                                  _device.address);
                          print('Connected to the device');

                          connection.input?.listen((Uint8List data) {
                            print('Data incoming: ${ascii.decode(data)}');
                            connection.output.add(data); // Sending data

                            if (ascii.decode(data).contains('!')) {
                              connection.finish(); // Closing connection
                              print('Disconnecting by local host');
                            }
                          }).onDone(() {
                            print('Disconnected by remote request');
                          });
                        } catch (exception) {
                          print('Cannot connect, exception occured');
                        }
                      },
                    ))
                .toList(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  "Perangkat Yang Tersedia",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
              ],
            ),
          ),
          Expanded(
            child: Wrap(
              children: Provider.of<Bluetooth>(context)
                  .availabledevices
                  .map((_device) => BluetoothDeviceListEntry(
                        device: _device.device,
                        enabled: true,
                        onTap: () async {
                          print("Item");
                          try {
                            BluetoothConnection connection =
                                await BluetoothConnection.toAddress(
                                    _device.device.address);
                            print('Connected to the device');

                            connection.input?.listen((Uint8List data) {
                              print('Data incoming: ${ascii.decode(data)}');
                              connection.output.add(data); // Sending data

                              if (ascii.decode(data).contains('!')) {
                                connection.finish(); // Closing connection
                                print('Disconnecting by local host');
                              }
                            }).onDone(() {
                              print('Disconnected by remote request');
                            });
                          } catch (exception) {
                            print('Cannot connect, exception occured');
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
