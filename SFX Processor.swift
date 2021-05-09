//
//  SFX Processor.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 01.10.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation
import AVFoundation
import Cocoa

class SFX {
    private static var player = AVAudioPlayer()
    private static let synth = AVSpeechSynthesizer()
    public static var voiceIdentifier: String? = nil
    private static let preferredVoices = ["ava.premium", "samantha.premium", "daniel", "alex"]
    
    public enum Effects: String {
        case powerOn = "PowOn"
        case buttonClick = "Button"
        case radioSetup = "RadioSetup"
    }
    
    public static func playSFX(sfx: Effects){
        print(AVSpeechSynthesisVoice.speechVoices())
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
    
    public static func playSFX(sfx: String){
        NSSound(named: sfx)?.play()
    }
    
    public static func shutUp(speaker: Bool = false){
        player.stop()
        if speaker { synth.stopSpeaking(at: .immediate) }
    }
    
    public static func testVoices() {
        print(AVSpeechSynthesisVoice.speechVoices())
    }
    
    public static func speak(say: String, lang: String) {
        let utterance = AVSpeechUtterance(string: say)
        switch lang {
            case "en":
                if voiceIdentifier == nil {
                    for s in preferredVoices{
                        let d = "com.apple.speech.synthesis.voice." + s
                        if AVSpeechSynthesisVoice(identifier: d) != nil {
                            voiceIdentifier = d
                            break
                        }
                    }
                    if voiceIdentifier == nil {
                        ViewController.defaults.set(0, forKey: "narrator")
                        AutomneCore.displayAlert(title: "No voices found", message: "Automne was unable to find any voices downloaded on this machine. Narrator will be switched off. Refer to manual in order to download a voice")
                        return
                    }
                }
                utterance.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier!)
            case "ru-RU":
                let d = "com.apple.speech.synthesis.voice.milena.premium"
                if AVSpeechSynthesisVoice(identifier: d) != nil {
                    utterance.voice = AVSpeechSynthesisVoice(identifier: d)
                } else {
                    utterance.voice = AVSpeechSynthesisVoice(language: lang)
                }
            default:
                utterance.voice = AVSpeechSynthesisVoice(language: lang)
        }

        utterance.rate = 0.4
        utterance.volume = 0.7
        utterance.postUtteranceDelay = 0.7
        playSFX(sfx: "Blow")
        synth.speak(utterance)
    }
    
    public static func speakWelcome(){
        speak(say: AutomneAxioms.specialWelcomeNarratives.randomElement()!, lang: "en")
    }
    
    public static func composeAndSpeak(track: String, artist: String) -> (Bool, String?) {
        if synth.isSpeaking { return (false, "already speaking") }
        let a = Int.random(in: 1...7)
        if a == 1 || a == 2 {
            let s = AutomneAxioms.trackNarratives.randomElement()
            let d = a == 1 ? track : artist
            let f = s!.0.replacingOccurrences(of: "$", with: a == 1 ? "track" : "artist")
            let lang: String
            if d.isLatin { lang = "en" }
            else if d.isCyrillic { lang = "ru-RU" }
            else { return (false, "difficult phrase: " + d) }
            if s!.1 { speak(say: f, lang: "en") }
            speak(say: d, lang: lang)
            if !s!.1 { speak(say: f, lang: "en") }
        } else if a == 3 || a == 4 {
            let s: String
            if a == 3 {
                s = AutomneAxioms.messages.randomElement()!
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
                        return (false, "hour err")
                }
                s = AutomneAxioms.specialTimeNarratives[d]!.randomElement()!
            }
            if s.isLatin {
                speak(say: s, lang: "en")
            } else if s.isCyrillic {
                speak(say: s, lang: "ru-RU")
            } else {
                return (false, "difficult phrase: " + s)
            }
        } else {
            return (false, "rnd case")
        }
        return (true, nil)
    }
}
