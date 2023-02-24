
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class RemoteNetwork extends ChangeNotifier {
  String url = "";
  String robocarName = "";
  var wifiName;
  var wifiIp;

  void Network() async {
    final _networkInfo = NetworkInfo();

    wifiName = await _networkInfo.getWifiName(); // "FooNetwork"
    final wifiBssid = await _networkInfo.getWifiBSSID(); // 11:22:33:44:55:66
    wifiIp = await _networkInfo.getWifiIP(); // 192.168.1.43
    final wifiSubmask = await _networkInfo.getWifiSubmask(); // 255.255.255.0
    final wifiBroadcast =
        await _networkInfo.getWifiBroadcast(); // 192.168.1.255
    final wifiGateway = await _networkInfo.getWifiGatewayIP(); // 192.168.1.1

    notifyListeners();
  }

  void SettingRobocar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              width: 60,
              child: Divider(
                thickness: 3,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                ListTile(
                  title: Text("Robocar 1"),
                  subtitle: Text("IP : 192.168.1.100"),
                  onTap: () {
                    url = "192.168.1.100";
                    robocarName = "Robocar 1";
                    Navigator.pop(context);
                    notifyListeners();
                  },
                ),
                ListTile(
                  title: Text("Robocar 2"),
                  subtitle: Text("IP : 192.168.1.101"),
                  onTap: () {
                    url = "192.168.1.101";
                    robocarName = "Robocar 2";
                    Navigator.pop(context);
                    notifyListeners();
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void Forward() async {
    try {
      var response = await http.get(Uri.parse("http://$url/forward"));
      print(response.statusCode);
    } catch (e) {}
  }

  void Backward() async {
    try {
      var response = await http.get(Uri.parse("http://$url/backward"));
      print(response.statusCode);
    } catch (e) {}
  }

  void Left() async {
    try {
      var response = await http.get(Uri.parse("http://$url/left"));
      print(response.statusCode);
    } catch (e) {}
  }

  void Right() async {
    try {
      var response = await http.get(Uri.parse("http://$url/right"));
      print(response.statusCode);
    } catch (e) {}
  }

  void Stop() async {
    try {
      var response = await http.get(Uri.parse("http://$url/stop"));
      print(response.statusCode);
    } catch (e) {}
  }
}
