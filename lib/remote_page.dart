import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:robocar_orbit/provider/remote_network.dart';
import 'package:robocar_orbit/provider/voice_recognition.dart';

class RemotePage extends StatelessWidget {
  RemotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robocar Remote"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset("assets/images/orbit.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                          height: 50,
                          child: TextButton.icon(
                              onPressed: () {
                                Provider.of<RemoteNetwork>(context,
                                        listen: false)
                                    .SettingRobocar(context);
                              },
                              icon: Icon(Icons.car_rental),
                              label: Text(Provider.of<RemoteNetwork>(context)
                                  .robocarName))),
                    ),
                  ),
                  Card(
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Icon(
                          Provider.of<RemoteNetwork>(context).wifiIp != null
                              ? Icons.wifi
                              : Icons.wifi_off),
                    ),
                  ),
                ],
              ),
              Card(
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          InkWell(
                              onTapDown: (details) {
                                context.read<RemoteNetwork>().Left();
                              },
                              onTapUp: (details) {
                                context.read<RemoteNetwork>().Stop();
                              },
                              child: Image.asset("assets/icons/arrow_left.png",
                                  width: 70)),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTapDown: (details) {
                              context.read<RemoteNetwork>().Forward();
                            },
                            onTapUp: (details) {
                              context.read<RemoteNetwork>().Stop();
                            },
                            child: Image.asset(
                              "assets/icons/arrow_up.png",
                              width: 70,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: InkWell(
                              onTapDown: (details) {
                                context.read<RemoteNetwork>().Stop();
                              },
                              child: Image.asset(
                                "assets/icons/stop.png",
                                width: 70,
                              ),
                            ),
                          ),
                          InkWell(
                            onTapDown: (details) {
                              context.read<RemoteNetwork>().Backward();
                            },
                            onTapUp: (details) {
                              context.read<RemoteNetwork>().Stop();
                            },
                            child: Image.asset("assets/icons/arrow_down.png",
                                width: 70),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTapDown: (details) {
                              context.read<RemoteNetwork>().Right();
                            },
                            onTapUp: (details) {
                              context.read<RemoteNetwork>().Stop();
                            },
                            child: Image.asset(
                              "assets/icons/arrow_right.png",
                              width: 70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<VoiceRecognition>(
                builder: (context, state, child) {
                  return Card(
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        children: [
                          Text("Tekan dan Tahan lalu Ucapkan Perintah",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTapDown: (details) async {
                              state.speechTapDown();
                            },
                            onTapUp: (details) {
                              state.speechTapUp();
                            },
                            child: AvatarGlow(
                              glowColor: Colors.red,
                              endRadius: 60.0,
                              showTwoGlows: true,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[100],
                                  child: Image.asset(
                                      state.tapSpeech == true
                                          ? "assets/icons/mic.png"
                                          : "assets/icons/mic_mute.png",
                                      width: 50),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          state.speechError != ""
                              ? Text(state.speechError,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                              : Container(),
                          SizedBox(height: 3),
                          Container(
                            width: 250,
                            padding: EdgeInsets.all(6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Text(state.speechText,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
