import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Controls extends StatefulWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  final databaseReference = FirebaseDatabase.instance.ref();
  String doorStatus = '';
  String fireStatus = '';

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp();

    // Listen for changes in the door status
    databaseReference.child('Sensor/door_stat').onValue.listen((event) {
      setState(() {
        Object? status = event.snapshot.value;
        doorStatus = status == 0 ? 'Closed' : 'Opened';
      });
    });

    // Listen for changes in the fire status
    databaseReference.child('Sensor/fire_stat').onValue.listen((event) {
      setState(() {
        Object? status = event.snapshot.value;
        fireStatus = status == 0 ? 'Safe' : 'Fire Detected';
      });
    });
  }

  void turnOnLED() {
    // Write code to turn on the LED on the ESP32
    databaseReference.child('Sensor/led').set(1);
  }

  void turnOffLED() {
    // Write code to turn off the LED on the ESP32
    databaseReference.child('Sensor/led').set(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Controls"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Door Status: $doorStatus',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Fire Status: $fireStatus',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: turnOnLED,
                  child: const Text("Turn On"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: turnOffLED,
                  child: const Text("Turn Off"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
