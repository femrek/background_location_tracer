
class CurrentData {

  CurrentData({
    this.latitude,
    this.longitude,
    this.altitude,
    this.speed,
    this.bearing,
    this.accuracy,
    this.timeAtMillis,
    this.isAddToPathNodes,
  });

  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double bearing;
  final double accuracy;
  final int timeAtMillis;
  final bool isAddToPathNodes;

  @override
  String toString() {
    return "latitude: $latitude | " +
    "longitude: $longitude | " +
    "altitude: $altitude | " +
    "speed: $speed | " +
    "bearing: $bearing | " +
    "accuracy: $accuracy | " +
    "timeAtMillis: $timeAtMillis | " +
    "isAddToPathNodes: $isAddToPathNodes"
    ;
  }
}