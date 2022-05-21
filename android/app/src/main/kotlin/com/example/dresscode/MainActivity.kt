package com.example.dresscode

import android.content.Context
import android.net.wifi.WifiManager
import androidx.core.content.getSystemService
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.util.Locale


class MainActivity : FlutterFragmentActivity() {
    private val channel = "com.example.dresscode/ip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getIp" -> {
                    val ip = getIp(applicationContext)
                    when {
                        ip.lowercase(Locale.getDefault()).contains("wifi") -> result.error(
                            "ERROR", "Could not get device ip", null
                        )
                        else -> result.success(ip)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getIp(context: Context): String {
        return context.getSystemService<WifiManager>().let {
            when {
                it == null -> "No wifi available"
                !it.isWifiEnabled -> "Wifi is disabled"
                it.connectionInfo == null -> "Wifi not connected"
                else -> {
                    val ip = it.connectionInfo.ipAddress
                    ((ip and 0xFF).toString() + "." + (ip shr 8 and 0xFF) + "." + (ip shr 16 and 0xFF) + "." + (ip shr 24 and 0xFF))
                }
            }
        }
    }
}
