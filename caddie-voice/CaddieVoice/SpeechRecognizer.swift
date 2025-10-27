//
//  SpeechRecognizer.swift
//  CaddieVoice
//
//  Copied from vCaddie project
//

import Foundation
import Speech
import AVFoundation
import Combine

/// ObservableObject you can use in SwiftUI to drive a live transcript bubble.
final class SpeechRecognizer: ObservableObject {
    // MARK: Published properties
  @Published var transcript   = ""
  @Published var isRecording  = false

    // MARK: Private AV/Speech properties
  private let audioEngine     = AVAudioEngine()
  private let request         = SFSpeechAudioBufferRecognitionRequest()
  private var recognitionTask : SFSpeechRecognitionTask?
  private let recognizer      = SFSpeechRecognizer(locale: .current)

    // MARK: Public API

    /// Call once (after permissions are granted) to begin streaming mic → transcript.
  func startRecording() throws {
    try checkPermissions()
    try configureAudioSession()
    try startAudioEngine()
    startRecognitionTask()
    DispatchQueue.main.async { self.isRecording = true }
  }

    /// Stops the current recording & recognition task.
  func stopRecording() {
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
    recognitionTask?.finish()
    recognitionTask = nil
    DispatchQueue.main.async { self.isRecording = false }
  }

    // MARK: Private helpers

    /// Ensure the user has already granted both Speech and Microphone access.
  private func checkPermissions() throws {
    guard SFSpeechRecognizer.authorizationStatus() == .authorized
    else { throw SpeechError.speechNotAuthorized }
    
    // For macOS, we don't use AVAudioSession, so we skip microphone permission check
    // The system will handle microphone permissions when we try to use it
  }

    /// Configure the audio engine for recording (macOS version).
  private func configureAudioSession() throws {
    // On macOS, we don't need to configure AVAudioSession
    // The AVAudioEngine will handle audio configuration automatically
  }

    /// Install the tap on the mic and start the engine.
  private func startAudioEngine() throws {
    let inputNode = audioEngine.inputNode
    let format    = inputNode.outputFormat(forBus: 0)

    request.shouldReportPartialResults = true
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
      self.request.append(buffer)
    }

    audioEngine.prepare()
    try audioEngine.start()
  }

    /// Kick off the Speech framework recognition task.
  private func startRecognitionTask() {
    recognitionTask = recognizer?.recognitionTask(with: request) { [weak self] result, error in
      guard let self = self else { return }

      if let r = result {
        DispatchQueue.main.async {
          self.transcript = r.bestTranscription.formattedString
        }
      }

      if error != nil || (result?.isFinal ?? false) {
        self.stopRecording()
      }
    }
  }

  deinit {
    stopRecording()
  }
}

  // MARK: - Errors

extension SpeechRecognizer {
  enum SpeechError: LocalizedError {
    case speechNotAuthorized, micNotAuthorized

    var errorDescription: String? {
      switch self {
        case .speechNotAuthorized:
          return "Speech recognition permission was not granted."
        case .micNotAuthorized:
          return "Microphone permission was not granted."
      }
    }
  }
}
