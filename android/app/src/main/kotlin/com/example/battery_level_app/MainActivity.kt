package com.example.battery_level_app

import android.content.*
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "battery_level_app/battery"
    private val EVENT_CHANNEL = "battery_level_app/charging"
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(MyStreamHandler(context))

        channel.setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val arguments = call.arguments() as Map<String, String>
                val name = arguments["name"]

                val batteryLevel = getBatteryLevel()

                result.success("$name $batteryLevel%")
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100
        }

        return batteryLevel
    }


}

class MyStreamHandler (private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventSink?) {
        if(events == null) return

        receiver = initReceiver(events)
        context.registerReceiver(receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))


    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(receiver)
        receiver = null
    }

    private  fun initReceiver(events: EventSink): BroadcastReceiver {
        return  object  : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) {
                val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)

                when (status) {
                    BatteryManager.BATTERY_STATUS_CHARGING -> events.success("Battery is charging")
                    BatteryManager.BATTERY_STATUS_FULL -> events.success("Battery is full")
                    BatteryManager.BATTERY_STATUS_DISCHARGING -> events.success("Battery is discharging")
                }
            }
        }
    }

}
