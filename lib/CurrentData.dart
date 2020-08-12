
class CurrentData {

  CurrentData({
    this.latitude,
    this.longitude,
    this.altitude,
    this.speed,
    this.bearing,
    this.accuracy,
    this.timeAtMillis,
  });

  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double bearing;
  final double accuracy;
  final int timeAtMillis;
}