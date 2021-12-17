import 'package:battery_level_app/ios_native_service/ios_native_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int batteryLevel = 0;

  @override
  Widget build(BuildContext context) {
    print(batteryLevel);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Level App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Current Battery Level is $batteryLevel'),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final batteryLevel = IosNativeService.getBatteryLevel();
                    });
                  },
                  child: const Text('Get battery level'))
            ],
          ),
        ),
      ),
    );
  }
}
