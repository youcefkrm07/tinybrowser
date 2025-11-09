package com.tiny.browser

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import com.ryanheise.audioservice.AudioServicePlugin

class MainApplication : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        AudioServicePlugin.setPluginRegistrantCallback(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
    }
}
