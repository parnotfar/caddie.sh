//
//  TTSManager.swift
//  CaddieVoice
//
//  Copied from vCaddie project
//

import AVFoundation

class TTSManager {
  static let shared = TTSManager()
  private let synthesizer = AVSpeechSynthesizer()

  private var delegateWrapper: Delegate?

  /// Speak the text, then call the completion.
  func speak(_ text: String, completion: @escaping ()->Void) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    utterance.rate = 0.45

    let wrapper = Delegate(completion)
    delegateWrapper = wrapper

    synthesizer.delegate = wrapper
    synthesizer.speak(utterance)
  }
  
  /// Speak the text without completion callback
  func speak(_ text: String) {
    speak(text) { }
  }

  private class Delegate: NSObject, AVSpeechSynthesizerDelegate {
    let completion: ()->Void
    init(_ completion: @escaping ()->Void) {
      self.completion = completion
    }

    func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
      completion()
    }
  }
}
