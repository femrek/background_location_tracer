import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CurrentData.dart';

class BackgroundLocationTracer {
  static const MethodChannel _channel =
      const MethodChannel('background_location_tracer');


  static Future<String> get startService async {
    final String errorMessage = await _channel.invokeMethod('startService');
    if (errorMessage == null) {
      _enableLocationListener();
    }
    return errorMessage;
  }

  static Future<String> get stopService async {
    final String errorMessage = await _channel.invokeMethod('stopService');
    if (errorMessage == null) {
      _disableLocationListener();
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


  static Future<Double> get currentSpeed async {
    final Double currentSpeed = await _channel.invokeMethod("getCurrentSpeed");
    return currentSpeed;
  }

  static Future<Double> get pathNodes async {
    final Double pathNodes = await _channel.invokeMethod("getPathNodes");
    return pathNodes;
  }



  static void registerOnLocationUpdateListener(ValueChanged<CurrentData> onLocationUpdate) {
    _onLocationUpdate = onLocationUpdate;
  }

  static ValueChanged<CurrentData> _onLocationUpdate;

  static const EventChannel _streamChannel =
    const EventChannel('background_location_tracer_stream');
  static StreamSubscription _locationSubscription;

  static void _enableLocationListener() {
    if (_locationSubscription == null)
      _locationSubscription = _streamChannel.receiveBroadcastStream().listen(_streamListener);
  }

  static void _disableLocationListener() {
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
      );
      if (_onLocationUpdate != null)
        _onLocationUpdate(data);
    }
  }

}
