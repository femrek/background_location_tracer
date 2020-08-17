import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CurrentData.dart';

export 'CurrentData.dart';

class BackgroundLocationTracer {
  static const MethodChannel _channel =
      const MethodChannel('background_location_tracer');


  static Future<String> get startService async {
    final String errorMessage = await _channel.invokeMethod('startService');
    if (errorMessage == null) {
      enableLocationListener();
    }
    return errorMessage;
  }

  static Future<String> get stopService async {
    final String errorMessage = await _channel.invokeMethod('stopService');
    if (errorMessage == null) {
      disableLocationListener();
    }
    return errorMessage;
  }

  static Future<String> get resumeService async {
    final String errorMessage = await _channel.invokeMethod('resumeService');
    return errorMessage;
  }

  static Future<String> get pauseService async {
    final String errorMessage = await _channel.invokeMethod('pauseService');
    return errorMessage;
  }


  static Future<bool> get isServiceStarted async {
    final bool isServiceStarted = await _channel.invokeMethod('isServiceStarted');
    return isServiceStarted;
  }

  static Future<bool> get isServiceRunning async {
    final bool isServiceRunning = await _channel.invokeMethod('isServiceRunning');
    return isServiceRunning;
  }


  static Future<Set<CurrentData>> get pathNodes async {
    final pathNodesInput = await _channel.invokeMethod("getPathNodes");
    Set<CurrentData> pathNodesResult = Set();

    if (pathNodesInput is List) {
      for (Map pathNode in pathNodesInput) {
        CurrentData data = CurrentData(
          latitude: pathNode['currentPositionLat'],
          longitude: pathNode['currentPositionLng'],
          altitude: pathNode['currentAltitude'],
          speed: pathNode['currentSpeed'],
          bearing: pathNode['currentBearing'],
          accuracy: pathNode['currentAccuracy'],
          timeAtMillis: pathNode['currentTimeAtMillis'],
        );
        pathNodesResult.add(data);
      }
      return pathNodesResult;
    } else {
      print(pathNodesInput.runtimeType.toString());
      Set<CurrentData> errorList = Set();
      errorList.add(CurrentData(latitude: 0));
      return errorList;
    }
  }



  static void registerOnLocationUpdateListener(ValueChanged<CurrentData> onLocationUpdate) {
    _onLocationUpdate = onLocationUpdate;
  }

  static ValueChanged<CurrentData> _onLocationUpdate;

  static const EventChannel _streamChannel =
    const EventChannel('background_location_tracer_stream');
  static StreamSubscription _locationSubscription;

  static void enableLocationListener() {
    if (_locationSubscription == null)
      _locationSubscription = _streamChannel.receiveBroadcastStream().listen(_streamListener);
  }

  static void disableLocationListener() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
      _locationSubscription = null;
    }
  }

  static void _streamListener(Object event) {
    if (event is Map) {
      CurrentData data = CurrentData(
        latitude: event['currentPositionLat'],
        longitude: event['currentPositionLng'],
        altitude: event['currentAltitude'],
        speed: event['currentSpeed'],
        bearing: event['currentBearing'],
        accuracy: event['currentAccuracy'],
        timeAtMillis: event['currentTimeAtMillis'],
        isAddToPathNodes: event['isAddToPathNodes'],
      );
      if (_onLocationUpdate != null)
        _onLocationUpdate(data);
    }
  }

}
