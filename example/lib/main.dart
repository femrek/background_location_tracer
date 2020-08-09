import 'package:background_location_tracer/CurrentData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:background_location_tracer/background_location_tracer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    BackgroundLocationTracer.registerOnLocationUpdateListener((CurrentData value) {
      setState(() {
        _currentLat = value.latitude;
        _currentLng = value.longitude;
        _currentSpeed = value.speed;
      });
    });
  }

  String _resultMessage = "";
  double _currentSpeed = 0.0;
  double _currentLat = 0.0;
  double _currentLng = 0.0;


  void _startService() async {
    _resultMessage = await BackgroundLocationTracer.startService ?? "started";
    setState(() {});
  }
  void _stopService() async {
    _resultMessage = await BackgroundLocationTracer.stopService ?? "stopped";
    setState(() {});
  }
  void _resumeService() async {
    _resultMessage = await BackgroundLocationTracer.resumeService ?? "resumed";
    setState(() {});
  }
  void _pauseService() async {
    _resultMessage = await BackgroundLocationTracer.pauseService ?? "paused";
    setState(() {});
  }

  void _startStopClick() async {
    if (await BackgroundLocationTracer.isServiceStarted) {
      _stopService();
    } else {
      _startService();
    }
  }

  void _resumePauseClick() async {
    if (await BackgroundLocationTracer.isServiceRunning) {
      _pauseService();
    } else {
      _resumeService();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  _startStopClick();
                },
                child: Text('start or stop service'),
              ),
              RaisedButton(
                onPressed: () {
                  _resumePauseClick();
                },
                child: Text('resume or pause service'),
              ),
              Text(_resultMessage),
              Text('current position: $_currentLat, $_currentLng'),
              Text('current speed = $_currentSpeed'),
            ],
          ),
        ),
      ),
    );
  }
}
