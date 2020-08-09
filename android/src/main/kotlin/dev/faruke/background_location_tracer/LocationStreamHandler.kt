package dev.faruke.background_location_tracer

import android.location.LocationListener
import android.os.Bundle
import dev.faruke.background_location_tracer.service.LocationService.Companion.currentPositionLat
import dev.faruke.background_location_tracer.service.LocationService.Companion.currentPositionLng
import dev.faruke.background_location_tracer.service.LocationService.Companion.currentSpeed
import dev.faruke.background_location_tracer.service.LocationService.Companion.locationListener
import dev.faruke.background_location_tracer.service.LocationService.Companion.service
import io.flutter.plugin.common.EventChannel

class LocationStreamHandler : EventChannel.StreamHandler {


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: android.location.Location) {
                service?.updateNotification(location)

                currentPositionLat = location.latitude
                currentPositionLng = location.longitude
                currentSpeed = location.speed.toDouble()

                val map: HashMap<String, Any?> = hashMapOf(
                        Pair("currentPositionLat", currentPositionLat),
                        Pair("currentPositionLng", currentPositionLng),
                        Pair("currentSpeed", currentSpeed)
                )

                events?.success(map)

            }


            override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {
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