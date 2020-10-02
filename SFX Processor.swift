//
//  SFX Processor.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 01.10.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation
import AVFoundation

class SFX{
    private static var player = AVAudioPlayer()
    
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
    }
}
