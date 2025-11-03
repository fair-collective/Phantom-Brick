import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/lock_service.dart';
import 'services/trace_service.dart';
import 'utils/qr_generator.dart';

void main() => runApp(GlobalPhantomApp());

class GlobalPhantomApp extends StatefulWidget {
  @override _GlobalPhantomAppState createState() => _State();
}

class _State extends State<GlobalPhantomApp> {
  final SpeechToText _speech = SpeechToText();
  String status = "Global Phantom ready.";
  bool isListening = false;
  String qrCode = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    generateQR();
  }

  void _initSpeech() async {
    await _speech.initialize();
  }

  void _listen() async {
    if (!isListening) {
      await _speech.listen(
        onResult: (result) {
          setState(() => status = result.recognizedWords);
          if (result.finalResult && result.recognizedWords.toLowerCase().contains("phantom brick")) {
            _brickPhone();
          }
        },
      );
      setState(() => isListening = true);
    } else {
      await _speech.stop();
      setState(() => isListening = false);
    }
  }

  void _brickPhone() async {
    setState(() => status = "Bricking globally...");
    await LockService.brick();  // GSMA IMEI
    await TraceService.trace();  // Global OSINT
    setState(() => status = "Bricked worldwide. Evidence sent.");
  }

  void generateQR() {
    qrCode = QRGenerator.generate("global_signal_token");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Global Phantom Brick"), backgroundColor: Colors.black),
        body: Column(
          children: [
            Text(status, style: TextStyle(color: Colors.white, fontSize: 18)),
            ElevatedButton(
              onPressed: _listen,
              child: Text(isListening ? "Stop" : "Start Listening"),
            ),
            Text("Friend QR:"),
            Text(qrCode),  // QR widget
          ],
        ),
      ),
    );
  }
}
