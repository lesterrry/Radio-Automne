//
//  SFX Processor.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 01.10.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation
import AVFoundation

class SFX {
    private static var player = AVAudioPlayer()
    private static let synth = AVSpeechSynthesizer()
    public enum Effects: String {
        case powerOn = "PowOn"
        case buttonClick = "Button"
        case radioSetup = "RadioSetup"
    }
    
    public static func playSFX(sfx: Effects){
        if let url = Bundle.main.url(forResource: sfx.rawValue, withExtension: "mp3", subdirectory: "SFX") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.volume = 0.5
                player.play()
            } catch {
                print("ERROR: Couldn't load SFX file named " + sfx.rawValue)
            }
        }
    }
    
    public static func shutUp(){
        player.stop()
        synth.stopSpeaking(at: .immediate)
    }
    
    public static func speak(say: String, lang: String) {
        let utterance = AVSpeechUtterance(string: say)
        switch lang {
        case "en-US":
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.samantha")
        default:
            utterance.voice = AVSpeechSynthesisVoice(language: lang)
        }

        utterance.rate = 0.4
        utterance.volume = 1
        utterance.preUtteranceDelay = 1
        synth.speak(utterance)
    }
    
    public static func composeAndSpeak(track: String, artist: String) -> Bool {
        if synth.isSpeaking { return false }
        let a = Int.random(in: 1...7)
        if a == 1 || a == 2 {
            let s = AutomneAxioms.trackNarratives.randomElement()
            let d = a == 1 ? track : artist
            let f = s!.0.replacingOccurrences(of: "$", with: a == 1 ? "track" : "artist")
            let lang: String
            if d.isLatin { lang = "en-US" }
            else if d.isCyrillic { lang = "ru-RU" }
            else { return false}
            if s!.1 { speak(say: f, lang: "en-US") }
            speak(say: d, lang: lang)
            if !s!.1 { speak(say: f, lang: "en-US") }
        } else if a == 3 || a == 4 {
            let s: String
            if a == 3 {
                s = AutomneAxioms.specialNarratives.randomElement()!
            } else {
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let d: String
                switch hour {
                    case 0...7:
                        d = "night"
                    case 8...12:
                        d = "morning"
                    case 13...19:
                        d = "day"
                    case 20...23:
                        d = "evening"
                    default:
                        return false
                }
                s = AutomneAxioms.specialTimeNarratives[d]!.randomElement()!
            }
            if s.isLatin {
                speak(say: s, lang: "en-US")
            } else {
                speak(say: s, lang: "ru-RU")
            }
        }
        return true
    }
}
