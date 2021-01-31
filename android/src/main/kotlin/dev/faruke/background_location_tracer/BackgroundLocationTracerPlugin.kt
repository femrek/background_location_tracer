package dev.faruke.background_location_tracer

import androidx.annotation.NonNull;
import dev.faruke.background_location_tracer.LocationService.Companion.context

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** BackgroundLocationTracerPlugin */
class BackgroundLocationTracerPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var methodChannel : MethodChannel
  private lateinit var streamChannel: EventChannel
  private lateinit var streamSubscription: EventChannel.StreamHandler

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    methodChannel.setMethodCallHandler(this);

    streamSubscription = LocationStreamHandler()
    streamChannel = EventChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME_STREAM)
    streamChannel.setStreamHandler(streamSubscription)

    context = flutterPluginBinding.applicationContext
  }

  companion object {
    const val CHANNEL_NAME = "background_location_tracer"
    const val CHANNEL_NAME_STREAM = "background_location_tracer_stream"
    @JvmStatic
    fun registerWith(registrar: PluginRegistry.Registrar) {
      val channel = MethodChannel(registrar.messenger(), "background_location_tracer")
      channel.setMethodCallHandler(BackgroundLocationTracerPlugin())
    }
  }
  

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "startService" -> {
        if (context != null){
          result.success(BackgroundLocationTracer.startService(context!!))
        }
      }
      "stopService" -> {
        result.success(BackgroundLocationTracer.stopService())
      }
      "resumeService" -> {
        result.success(BackgroundLocationTracer.resumeService())
      }
      "pauseService" -> {
        result.success(BackgroundLocationTracer.pauseService())
      }
      "isServiceStarted" -> {
        result.success(BackgroundLocationTracer.isServiceStarted())
      }
      "isServiceRunning" -> {
        result.success(BackgroundLocationTracer.isServiceRunning())
      }
      "getPathNodes" -> {
        result.success(BackgroundLocationTracer.getPathNodes())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }
}
