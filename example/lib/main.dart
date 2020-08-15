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

  Future<Set<CurrentData>> _pathNodesFuture;

  @override
  void initState() {
    super.initState();
    BackgroundLocationTracer.registerOnLocationUpdateListener((CurrentData value) {
      setState(() {
        _currentLat = value.latitude;
        _currentLng = value.longitude;
        _currentSpeed = value.speed;
        _currentAlt = value.altitude;
        _currentBearing = value.bearing;
        _currentAccuracy = value.accuracy;
        _currentTime = value.timeAtMillis;
      });
    });
  }

  String _resultMessage = "";
  double _currentSpeed = 0.0;
  double _currentLat = 0.0;
  double _currentLng = 0.0;
  double _currentAlt = 0.0;
  double _currentBearing = 0.0;
  double _currentAccuracy = 0.0;
  int _currentTime = 0;


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

  Future<Set<CurrentData>> _updatePathNodes() async {
    Set<CurrentData> set = await BackgroundLocationTracer.pathNodes;
    return set;
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
              Text('current position: $_currentLat, $_currentLng, $_currentAlt'),
              Text('current speed = $_currentSpeed'),
              Text('current bearing = $_currentBearing'),
              Text('current accuracy = $_currentAccuracy'),
              Text('current time = $_currentTime'),
              Divider(),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _pathNodesFuture = _updatePathNodes();
                  });
                },
                child: Text('get path nodes'),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _pathNodesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              (snapshot.data as Set<CurrentData>).elementAt(index).timeAtMillis.toString(),
                            ),
                          );
                        },
                        itemCount: (snapshot.data as Set).length,
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        snapshot.error.toString(),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
