//
//  CommandProcessor.swift
//  CaddieVoice
//
//  Created by Caddie Voice System
//

import Foundation

class CommandProcessor {
    private let speechRecognizer = SpeechRecognizer()
    private let ttsManager = TTSManager.shared
    private let caddiePath = "/usr/local/bin/caddie"
    
    var isListening = false
    
    func startListening() {
        do {
            try speechRecognizer.startRecording()
            isListening = true
            ttsManager.speak("Listening...") { }
            print("🎤 Listening for voice command...")
        } catch {
            print("Failed to start listening: \(error)")
            ttsManager.speak("Failed to start listening") { }
        }
    }
    
    func stopListening() {
        speechRecognizer.stopRecording()
        let transcript = speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("🎤 Heard: '\(transcript)'")
        
        if let command = processRustExampleCommand(transcript) {
            executeCaddieCommand(command)
        } else {
            ttsManager.speak("Command not recognized") { }
            print("❌ Command not recognized: '\(transcript)'")
        }
        
        isListening = false
    }
    
    private func processRustExampleCommand(_ transcript: String) -> String? {
        let words = transcript.lowercased().components(separatedBy: .whitespaces)
        
        // Look for pattern: "rust run example <example-name>"
        if words.count >= 4 && 
           words[0] == "rust" && 
           words[1] == "run" && 
           words[2] == "example" {
            
            // Convert remaining words to kebab-case
            let exampleName = words[3...].joined(separator: "-")
            return "rust:run:example \(exampleName)"
        }
        
        return nil
    }
    
    private func executeCaddieCommand(_ command: String) {
        print("🚀 Executing: caddie \(command)")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: caddiePath)
        process.arguments = [command]
        
        // Capture output
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            if process.terminationStatus == 0 {
                ttsManager.speak("Command executed successfully") { }
                print("✅ Command executed successfully")
                if !output.isEmpty {
                    print("Output: \(output)")
                }
            } else {
                ttsManager.speak("Command failed") { }
                print("❌ Command failed with status: \(process.terminationStatus)")
                if !output.isEmpty {
                    print("Error: \(output)")
                }
            }
        } catch {
            ttsManager.speak("Error executing command") { }
            print("❌ Error executing command: \(error)")
        }
    }
}
