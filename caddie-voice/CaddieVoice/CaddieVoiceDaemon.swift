//
//  CaddieVoiceDaemon.swift
//  CaddieVoice
//
//  Created by Caddie Voice System
//

import Foundation
import Carbon

class CaddieVoiceDaemon {
    private let hotkeyManager = HotkeyManager()
    private let commandProcessor = CommandProcessor()
    
    func start() {
        print("🚀 Starting Caddie Voice Daemon...")
        fflush(stdout)  // Force output to appear immediately
        
        // Register global hotkey (V key)
        print("🔑 Registering hotkey...")
        fflush(stdout)
        hotkeyManager.registerHotkey()
        
        // Keep daemon running with Carbon event loop
        print("✅ Caddie Voice Daemon is running. Press Cmd+Option+V to activate voice commands.")
        fflush(stdout)
        
        // Audio feedback that daemon is ready
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            task.launchPath = "/usr/bin/say"
            task.arguments = ["Caddie voice daemon ready"]
            task.launch()
        }
        
        // Use standard run loop - Carbon events will be handled by the dispatcher target
        RunLoop.main.run()
    }
    
    func stop() {
        print("Stopping Caddie Voice Daemon...")
        hotkeyManager.unregisterHotkey()
        exit(0)
    }
}

// MARK: - Main Entry Point
@main
struct CaddieVoiceApp {
    static func main() {
        let daemon = CaddieVoiceDaemon()
        daemon.start()
    }
}
