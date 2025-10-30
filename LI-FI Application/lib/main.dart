import 'package:flutter/material.dart';
import 'dart:async';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiFi Flashlight Transmitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LiFiTransmitter(),
    );
  }
}

class LiFiTransmitter extends StatefulWidget {
  @override
  _LiFiTransmitterState createState() => _LiFiTransmitterState();
}

class _LiFiTransmitterState extends State<LiFiTransmitter> {
  String status = "Select a message to send";

  final Map<String, String> messages = {
    "Hi": "001",
    "Hello": "0001",
    "How are you?": "00001",
    "I am fine": "000001",
    "Ok": "0000001",
    "Good morning": "00000001",
    "Good afternoon": "000000001",
    "Good evening": "0000000001",
    "Thank you": "00000000001",
    "Sorry": "000000000001",
    "Welcome": "0000000000001",
    "What's up?": "00000000000001",
    "I'm busy": "000000000000001",
    "Call me": "0000000000000001",
    "Miss you": "00000000000000001",
    "See you soon": "000000000000000001",
    "Take care": "0000000000000000001",
    "Happy birthday": "00000000000000000001",
    "Congrats": "000000000000000000001",
    "Good night": "0000000000000000000001",
    "I love you": "00000000000000000000001",
    "Help me": "000000000000000000000001",
    "Where are you?": "0000000000000000000000001",
    "I'm coming": "00000000000000000000000001",
    "At home": "000000000000000000000000001",
    "On the way": "0000000000000000000000000001",
    "Wait a minute": "00000000000000000000000000001",
    "Meet me": "000000000000000000000000000001",
    "Be safe": "0000000000000000000000000000001",
    "Emergency": "00000000000000000000000000000001",
  };

  Future<void> toggleFlashlight(bool state) async {
    try {
      if (state) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      print("Torch error: $e");
    }
  }

  Future<void> transmitMessage(String binaryPattern) async {
    setState(() {
      status = "Sending...";
    });

    for (int i = 0; i < binaryPattern.length; i++) {
      String bit = binaryPattern[i];
      await toggleFlashlight(bit == "1");
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Turn off torch after transmission
    await toggleFlashlight(false);

    setState(() {
      status = "Message sent!";
    });
  }

  @override
  void dispose() {
    TorchLight.disableTorch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiFi Flashlight Transmitter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: messages.keys.map((msg) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () => transmitMessage(messages[msg]!),
                      child: Text(msg),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
