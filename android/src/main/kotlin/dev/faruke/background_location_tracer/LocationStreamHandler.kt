package dev.faruke.background_location_tracer

import android.location.LocationListener
import android.os.Bundle
import dev.faruke.background_location_tracer.service.LocationService.Companion.lastSpeed
import dev.faruke.background_location_tracer.service.LocationService.Companion.locationListener
import dev.faruke.background_location_tracer.service.LocationService.Companion.pathNodes
import dev.faruke.background_location_tracer.service.LocationService.Companion.service
import dev.faruke.background_location_tracer.service.LocationService.Companion.isRunning
import io.flutter.plugin.common.EventChannel

class LocationStreamHandler : EventChannel.StreamHandler {


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: android.location.Location) {
                service?.updateNotification(location)

                val map: HashMap<String, Any?> = hashMapOf(
                        Pair("currentPositionLat", location.latitude),
                        Pair("currentPositionLng", location.longitude),
                        Pair("currentAltitude", location.altitude),
                        Pair("currentSpeed", location.speed.toDouble()),
                        Pair("currentBearing", location.bearing.toDouble()),
                        Pair("currentAccuracy", location.accuracy.toDouble()),
                        Pair("currentTimeAtMillis", location.time)
                )

                if (((location.speed != 0.0f || lastSpeed != 0.0) || pathNodes.size == 0) && isRunning) {
                    pathNodes.add(map)
                }

                lastSpeed = location.speed.toDouble()

                events?.success(map)
            }

            override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {
                //events?.success(status)
            }

            override fun onProviderEnabled(provider: String) {
                //events?.success(true)
            }

            override fun onProviderDisabled(provider: String) {
                //events?.success(false)
            }
        }
        service?.resumeService()
    }

    override fun onCancel(arguments: Any?) {
        locationListener = null
    }
}