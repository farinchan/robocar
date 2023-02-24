import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocar_orbit/provider/bluetooth.dart';
import 'package:robocar_orbit/provider/remote_network.dart';
import 'package:robocar_orbit/provider/voice_recognition.dart';
import 'package:robocar_orbit/remote_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Bluetooth()
            ..getBTState()
            ..stateChangeListener(),
        ),
        ChangeNotifierProvider(create: (context) => VoiceRecognition()),
        ChangeNotifierProvider(create: (context) => RemoteNetwork()..Network()),
      ],
      child: MaterialApp(
        home: RemotePage(),
        theme: ThemeData(
          useMaterial3: true,
          // primarySwatch: Colors.red,
          colorSchemeSeed: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
