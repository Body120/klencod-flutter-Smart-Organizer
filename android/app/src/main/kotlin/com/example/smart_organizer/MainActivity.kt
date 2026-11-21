package com.smart.app

import android.graphics.Bitmap
import android.graphics.Canvas
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "smart_organizer/apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    try {
                        result.success(getLaunchableApps())
                    } catch (exception: Exception) {
                        result.error("APP_DISCOVERY_ERROR", exception.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getLaunchableApps(): List<Map<String, String>> {
        val pm = packageManager

        return pm.getInstalledApplications(0)
            .filter { pm.getLaunchIntentForPackage(it.packageName) != null }
            .mapNotNull { app ->
                try {
                    val iconDrawable = pm.getApplicationIcon(app)
                    val bitmap = Bitmap.createBitmap(
                        96, 96, Bitmap.Config.ARGB_8888
                    )
                    val canvas = Canvas(bitmap)
                    iconDrawable.setBounds(0, 0, 96, 96)
                    iconDrawable.draw(canvas)

                    val output = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)
                    bitmap.recycle()

                    mapOf(
                        "name" to pm.getApplicationLabel(app).toString(),
                        "packageName" to app.packageName,
                        "icon" to Base64.encodeToString(
                            output.toByteArray(),
                            Base64.NO_WRAP
                        )
                    )
                } catch (_: Exception) {
                    null
                }
            }
            .sortedBy { it["name"]?.lowercase() ?: "" }
    }
}