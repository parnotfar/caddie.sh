//
//  HotkeyManager.swift
//  CaddieVoice
//
//  Created by Caddie Voice System
//

import Carbon
import Foundation

extension String {
    var fourCharCodeValue: UInt32 {
        guard self.count == 4 else { return 0 }
        var result: UInt32 = 0
        for char in self.utf8 {
            result = (result << 8) + UInt32(char)
        }
        return result
    }
}

class HotkeyManager {
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private let commandProcessor = CommandProcessor()
    
    func registerHotkey() {
        print("🔍 DEBUG: Starting Carbon hotkey registration...")
        
        let eventTarget = GetEventDispatcherTarget()
        if eventTarget == nil {
            print("❌ Unable to obtain Event Dispatcher target – Carbon event system not available")
            return
        }
        
        // Register Cmd+Option+V using Carbon
        let hotKeyID = EventHotKeyID(signature: OSType("PNF1".fourCharCodeValue), id: UInt32(1))
        
        let status = RegisterEventHotKey(
            UInt32(kVK_ANSI_V),  // V key
            UInt32(optionKey | cmdKey),  // Cmd+Option modifiers
            hotKeyID,
            eventTarget!,
            0,
            &hotKeyRef
        )
        
        print("🔍 DEBUG: RegisterEventHotKey status: \(status)")
        
        if status != noErr {
            print("❌ FAILED to register Carbon hotkey: \(status)")
            print("❌ This usually means the app still needs Input Monitoring permission.")
            print("❌ Go to System Settings → Privacy & Security → Input Monitoring and enable CaddieVoice, then restart the daemon.")
            return
        }
        
        print("✅ Carbon hotkey registered successfully")
        
        // Set up event handler
        var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        let handlerStatus = InstallEventHandler(
            eventTarget!,
            { (_, _, userData) -> OSStatus in
                guard let userData = userData else { return noErr }
                let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                manager.handleHotkeyPress()
                return noErr
            },
            1,
            &spec,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            &eventHandler
        )
        
        print("🔍 DEBUG: InstallEventHandler status: \(handlerStatus)")
        
        if handlerStatus != noErr {
            print("❌ FAILED to install Carbon event handler: \(handlerStatus)")
        } else {
            print("✅ Carbon event handler installed successfully")
            print("✅ Hotkey registered: Press Cmd+Option+V to activate voice commands")
        }
    }
    
    func unregisterHotkey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
    
    private func handleHotkeyPress() {
        print("🔥 HOTKEY PRESSED! Cmd+Option+V detected")
        fflush(stdout)
        
        DispatchQueue.main.async {
            if self.commandProcessor.isListening {
                print("🛑 Stopping voice listening...")
                fflush(stdout)
                self.commandProcessor.stopListening()
                // Audio feedback for stopping
                self.runSayCommand("Caddie stopped listening")
            } else {
                print("🎤 Starting voice listening...")
                fflush(stdout)
                self.commandProcessor.startListening()
                // Audio feedback for starting
                self.runSayCommand("Caddie listening")
            }
        }
    }
    
    private func runSayCommand(_ text: String) {
        let task = Process()
        task.launchPath = "/usr/bin/say"
        task.arguments = [text]
        task.launch()
    }
}
