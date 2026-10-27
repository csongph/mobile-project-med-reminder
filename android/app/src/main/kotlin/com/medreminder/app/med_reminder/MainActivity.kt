package com.medreminder.app.med_reminder

import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.app.NotificationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "med_reminder/storage"
    private val fileName = "med_reminder_data_v1.json"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            val file = File(filesDir, fileName)
            when (call.method) {
                "read" -> result.success(if (file.exists()) file.readText() else null)
                "write" -> {
                    val contents = call.arguments as? String
                    if (contents == null) result.error("invalid_data", "Expected JSON string", null)
                    else try {
                        file.writeText(contents)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("storage_error", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "med_reminder/alarm")
            .setMethodCallHandler { call, result ->
                val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    getSystemService(VibratorManager::class.java).defaultVibrator
                } else {
                    @Suppress("DEPRECATION")
                    getSystemService(VIBRATOR_SERVICE) as Vibrator
                }
                when (call.method) {
                    "canUseFullScreenIntent" -> {
                        val allowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            getSystemService(NotificationManager::class.java).canUseFullScreenIntent()
                        } else {
                            true
                        }
                        result.success(allowed)
                    }
                    "startAlarmVibration" -> {
                        if (vibrator.hasVibrator()) {
                            val pattern = longArrayOf(0, 900, 450, 900, 450, 1200)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                vibrator.vibrate(VibrationEffect.createWaveform(pattern, 0))
                            } else {
                                @Suppress("DEPRECATION")
                                vibrator.vibrate(pattern, 0)
                            }
                        }
                        result.success(null)
                    }
                    "stopAlarmVibration" -> {
                        vibrator.cancel()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
