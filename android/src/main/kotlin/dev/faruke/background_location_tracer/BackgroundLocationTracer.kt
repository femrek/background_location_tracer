package dev.faruke.background_location_tracer

import android.content.Context
import android.content.Intent
import android.os.Build
import dev.faruke.background_location_tracer.model.CurrentData
import dev.faruke.background_location_tracer.service.LocationService
import dev.faruke.background_location_tracer.service.LocationService.Companion.currentSpeed
import dev.faruke.background_location_tracer.service.LocationService.Companion.isRunning
import dev.faruke.background_location_tracer.service.LocationService.Companion.pathNodes
import dev.faruke.background_location_tracer.service.LocationService.Companion.service

abstract class BackgroundLocationTracer {

    companion object {

        fun startService(context: Context) : String? {
            if (service != null) {
                service!!.resumeService()
            } else {
                val intent = Intent(context, LocationService::class.java)
                if (!isRunning) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) context.startForegroundService(intent)
                    else context.startService(intent)
                }
            }
            return null
        }

        fun stopService() : String? {
            if (service == null) return "service not found"
            service!!.stopService()
            return null
        }

        fun resumeService() : String? {
            if (service == null) return "service not found"
            else if (isRunning) return "service already resumed"
            service!!.resumeService()
            return null
        }

        fun pauseService() : String? {
            if (service == null) return "service not found"
            else if (!isRunning) return "service already paused"
            service!!.pauseService()
            return null
        }


        fun isServiceStarted() : Boolean {
            if (service != null) return true
            return false
        }

        fun isServiceRunning() : Boolean {
            return isRunning
        }


        fun getCurrentSpeed() : Double {
            return currentSpeed
        }

        fun getPathNodes() : Set<CurrentData> {
            return pathNodes
        }

    }

}