package dev.faruke.background_location_tracer.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.PRIORITY_MIN
import dev.faruke.background_location_tracer.LocationStreamHandler
import dev.faruke.background_location_tracer.model.CurrentData


class LocationService : Service() {
    override fun onBind(p0: Intent?): IBinder? = null

    private var mLocationManager: LocationManager? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        startForeground()
        service = this
        resumeService()
        println("service starting")

        return START_STICKY
    }

    override fun onDestroy() {
        service = null
        pauseService()
        super.onDestroy()
    }

    fun stopService() {
        service = null
        pauseService()
        stopSelf()
    }

    fun resumeService() {
        isRunning = true

        if (locationListener == null) {
            return
        }

        initializeLocationManager()
        try {
            mLocationManager!!.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, LOCATION_INTERVAL, LOCATION_DISTANCE,
                    locationListener!!)
        } catch (ex: SecurityException) {
        } catch (ex: IllegalArgumentException) {
        }
    }

    fun pauseService() {
        isRunning = false
        initializeLocationManager()
        mLocationManager!!.removeUpdates(locationListener)
    }

    companion object {
        var service: LocationService? = null
        var context: Context? = null
        //var streamSubscription: LocationStreamHandler? = null
        var locationListener: LocationListener? = null

        var isRunning: Boolean = false

        val pathNodes: MutableSet<CurrentData> = mutableSetOf()

        var currentPositionLat: Double? = null
        var currentPositionLng: Double? = null
        var currentSpeed: Double = 0.0

        var notificationSmallIcon: Int = android.R.drawable.sym_def_app_icon
        var notificationLargeIcon: Bitmap? = null

        const val CHANNEL_ID = "notificationChannelID"
        private const val LOCATION_INTERVAL: Long = 3000
        private const val LOCATION_DISTANCE: Float = 0f
    }

    private fun initializeLocationManager() {
        if (mLocationManager == null) {
            mLocationManager = applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        }
    }

    fun updateNotification(location: Location) {
        if (service != null && service!!.notificationBuilder != null && service!!.notificationManager != null) {
            service!!.notificationBuilder!!.setContentText(location.latitude.toString() + ", " + location.longitude.toString())
            service!!.notificationManager!!.notify(101, service!!.notificationBuilder!!.build())
        }
    }


    var notification: Notification? = null
    var notificationBuilder: NotificationCompat.Builder? = null
    var notificationManager: NotificationManager? = null

    private fun startForeground() {
        val channelId =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    createNotificationChannel("My Background Service")
                } else {
                    // If earlier version channel ID is not used
                    // https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#NotificationCompat.Builder(android.content.Context)
                    ""
                }

        notificationBuilder = NotificationCompat.Builder(this, channelId)
        //val intent = Intent(this, MainActivity::class.java)
        notification = notificationBuilder!!.setOngoing(true)
                //.setContentIntent(PendingIntent.getActivity(mainActivity,0, intent, 0))
                .setContentTitle("service notification")
                .setContentText("service started")
                .setSmallIcon(notificationSmallIcon)
                .setLargeIcon(notificationLargeIcon)
                .setPriority(PRIORITY_MIN)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build()
        startForeground(101, notification)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(channelName: String): String {
        val chan = NotificationChannel(
                CHANNEL_ID,
                channelName, NotificationManager.IMPORTANCE_NONE)
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager!!.createNotificationChannel(chan)
        return CHANNEL_ID
    }

}