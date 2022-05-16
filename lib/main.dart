import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:popcorn_time/app.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

Future<AndroidDeviceInfo> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  return androidInfo;
}

class _MainState extends State<Main> {
  Future<AndroidDeviceInfo>? androidDeviceInfo;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      androidDeviceInfo = getDeviceInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AndroidDeviceInfo>(
      future: androidDeviceInfo,
      builder: (context, snapshot) => Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: snapshot.connectionState == ConnectionState.waiting
            ? MaterialApp(
                builder: ((context, child) => Scaffold(
                      backgroundColor:
                          SchedulerBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.blueGrey.shade900
                              : Colors.white70,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                    )),
              )
            : App(
                androidDeviceInfo: snapshot.data,
              ),
      ),
    );
  }
}
