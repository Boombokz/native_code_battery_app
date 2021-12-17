import 'dart:async';
import 'dart:math';

import 'package:battery_level_app/logic/platform_channels_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController streamController = StreamController<String>();

  @override
  void initState() {
    getCurrentBatteryLevel();
    super.initState();
  }

  getCurrentBatteryLevel() async {
    streamController.add(await PlatformChannelService.getBatteryLevel());
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Level App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => getCurrentBatteryLevel(),
              child: const Text('Get battery level'),
            ),
          ],
        ),
      ),
    );
  }
}
