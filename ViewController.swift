//
//  ViewController.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Cocoa
import Alamofire
import AVFoundation
import MediaPlayer

class View: NSView {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}

class ViewController: NSViewController{
    
    //*********************************************************************
    //SYSTEM
    //*********************************************************************
    static var systemStatus = AutomneProperties.SystemStatus.standby
    static var playbackControllerState = AutomneProperties.PlaybackControllerState.none
    static let VERSION_NAME = "Samoyed"
    
    //*********************************************************************
    //OUTLETS
    //*********************************************************************
    @IBOutlet var bar: NSTouchBar!
    @IBOutlet weak var terminalImage: NSImageView!
    @IBOutlet weak var standbyButton: NSButton!
    @IBOutlet weak var box: NSImageView!
    @IBOutlet weak var mainLabel: NSTextField!
    @IBOutlet weak var TBLabel: NSTextField!
    @IBOutlet weak var frequencyControllerLabel: NSTextField!
    @IBOutlet weak var volumeKnob: NSImageView!
    @IBOutlet weak var statusLight: NSImageView!
    @IBOutlet weak var TBStatusLight: NSImageView!
    @IBOutlet weak var terminal: NSTextField!
    @IBOutlet weak var frequencyControllerLight_stream: NSImageView!
    @IBOutlet weak var frequencyControllerLight_tune: NSImageView!
    @IBOutlet weak var frequencyControllerLight_new: NSImageView!
    @IBOutlet weak var frequencyControllerLight_memory: NSImageView!
    @IBOutlet weak var glitchStripe: NSImageView!
    @IBOutlet weak var playbackControllerLight_play: NSImageView!
    @IBOutlet weak var playbackControllerLight_sleep: NSImageView!
    @IBOutlet weak var playbackControllerLight_stream: NSImageView!
    @IBOutlet weak var playbackControllerLight_pause: NSImageView!
    @IBOutlet weak var playbackControllerLight_deepwave: NSImageView!
    @IBOutlet weak var playbackControllerLight_loading: NSImageView!
    @IBOutlet weak var playbackControllerLight_error: NSImageView!
    var allLights: [NSImageView] = []
    
    //*********************************************************************
    //ACTIONS
    //*********************************************************************
    ///Frequency Controller
    @IBAction func freqControlUpClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby {
            let i = ViewController.selectedFrequencyIndex
            if i < ViewController.retrievedFrequencies.count - 1 {
                switchFrequency(to: ViewController.retrievedFrequencies[i + 1], index: i + 1)
            }
        }
    }
    @IBAction func freqControlDownClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby {
            let i = ViewController.selectedFrequencyIndex
            if i > 0 {
                switchFrequency(to: ViewController.retrievedFrequencies[i - 1], index: i - 1)
            }
        }
    }
    @IBAction func freqControlSetClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby && ViewController.systemStatus != .error {
            ViewController.player.pause()
            ViewController.mainDisplayState = .frequency
            let fr = ViewController.selectedFrequency!
            if fr.isStream! {
                self.startStream(frequency: fr)
            } else {
                self.retrieveTracks(frequency: fr)
            }
        }
    }
    
    ///System
    @IBAction func standbyClicked(_ sender: Any) {
        if ViewController.systemStatus == .standby{
            powerOn()
        }
        else if ViewController.systemStatus != .busy{
            powerOff()
            SFX.playSFX(sfx: .buttonClick)
        }
    }
    
    ///Playback Controller
    @IBAction func pauseClicked(_ sender: Any) {
        if ViewController.playbackControllerState == .playing {
            pause()
        }
    }
    @IBAction func playClicked(_ sender: Any) {
        if ViewController.systemStatus == .ready ||
            ViewController.playbackControllerState == .playing {
            play(from: ViewController.playbackIndex, init: true)
        }
        else if ViewController.playbackControllerState == .paused {
            resume()
        }
        else if ViewController.systemStatus == .unset {
            tprint("Frequency not set")
        }
    }
    @IBAction func setupClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby
                && !ViewController.inMenu{
                let els = [
                    SetupMenu.SetupMenuElement(
                        title: "Display artwork",
                        value: ViewController.defaults.integer(forKey: "artwork"),
                        bounds: (0,2),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Appearance",
                        value: (ViewController.defaults.integer(forKey: "appearance") == 0 ? 1 : ViewController.defaults.integer(forKey: "appearance")),
                        bounds: (1,7),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Quick boot",
                        value: ViewController.defaults.integer(forKey: "qboot"),
                        bounds: (0,1),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Sleep timer",
                        value: 0,
                        bounds: (0,9),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Server",
                        value: ViewController.defaults.integer(forKey: "server"),
                        bounds: (1,2),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Verbose",
                        value: ViewController.defaults.integer(forKey: "log"),
                        bounds: (0,1),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Narrator",
                        value: ViewController.defaults.integer(forKey: "narrator"),
                        bounds: (0,1),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Deepwave Chance",
                        value: ViewController.defaults.integer(forKey: "deepwave_chance"),
                        bounds: (0,4),
                        isAction: false),
                    SetupMenu.SetupMenuElement(
                        title: "Deepwave Count",
                        value: ViewController.defaults.integer(forKey: "deepwave_count"),
                        bounds: (1,3),
                        isAction: false)]
                ViewController.smenu = SetupMenu.get(for: els)
                tclear(cache: true)
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true, noWipe: true)
                ViewController.inMenu = true
            }
            else if ViewController.inMenu{
                saveDefaults()
            }
    }
    @IBAction func helpClicked(_ sender: Any) {
        sendToGithub()
    }
    @IBAction func nextClicked(_ sender: Any) {
        if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
            advance()
        }
    }
    @IBAction func prevClicked(_ sender: Any) {
        if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
            reverse()
        }
    }
    @IBAction func shareClicked(_ sender: Any) {
        if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
            NSWorkspace.shared.open(URL(string: ViewController.currentTrack!.permalink_url!)!)
        }
    }
    @IBAction func diveClicked(_ sender: Any) {
        if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
            initDeepwave(with: ViewController.currentTrack!)
        }
    }
    
    //*********************************************************************
    //VARS
    //*********************************************************************
    static var player : AVPlayer = AVPlayer()
    static var smenu = SetupMenu(elements: [], selected: 0)
    static var playableQueue: [Track] = []
    static var playbackIndex = 0
    static var selectedFrequency: Frequency? = nil
    static var selectedFrequencyIndex = -1
    static var setFrequencyIndex = -1
    static var demandFrequencyID = ""
    static var setFrequency: Frequency? = nil
    static var retrievedFrequencies: [Frequency] = []
    static var ticker: Timer!
    static var mainDisplaySwitchTimer: Timer!
    static var sleepTimer: Timer!
    static var playerWaitingTimeoutTimer: Timer!
    static var terminalImageLeftTicks = 0
    static var terminalStripeLeftTicks = 0
    static var terminalImagePlaylistServed = false
    static var volumeKnobAngle: CGFloat = 0.0
    static var savedVolume = -1
    static var firstCall = true
    static var mainDisplayState = MainDisplayState.song
    static var inMenu = false
    static var playlist: Playlist? = nil
    static var TSBP = 0
    static var terminalCache = ""
    static var currentTrack: Track? = nil
    static var deepWaveInitiator: Track? = nil
    static var configFilePath: URL? = nil
    
    //*********************************************************************
    //CONSTS
    //*********************************************************************
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let defaults = UserDefaults.standard
    static let controlCenter = MPRemoteCommandCenter.shared()
    static let controlCenterInfo = MPNowPlayingInfoCenter.default()
    let fetchLogo = "### ### ### ### # #\n#   #    #  #   # #\n##  ###  #  #   ###\n#   #    #  #   # #\n#   ###  #  ### # #"
    static let states = [MainDisplayState.frequency, MainDisplayState.song, MainDisplayState.artist, MainDisplayState.time]
    static let streamStates = [MainDisplayState.frequency, MainDisplayState.song, MainDisplayState.time]
    static let fm = FileManager.default
    static let freqDemandPlaceholder = "ID: >"
    
    //*********************************************************************
    //FUNCTIONS
    //*********************************************************************
    override func viewDidAppear() {
        super.viewDidAppear()
        
//        MARK: This would be worth implementing in case i add Favourites in the future. Anyway it wont work now and is possibly iOS-only.
//        ViewController.controlCenter.likeCommand.addTarget {_ in
//            return .success
//        }
//        ViewController.controlCenter.likeCommand.isEnabled = true
        ViewController.controlCenter.togglePlayPauseCommand.addTarget{_ in
            if ViewController.playbackControllerState == .paused {
                self.resume()
                return .success
            } else if ViewController.playbackControllerState == .playing {
                self.pause()
                return .success
            } else {
                return .commandFailed
            }
        }
        ViewController.controlCenter.playCommand.addTarget {_ in
            if ViewController.playbackControllerState == .paused {
                self.resume()
                ViewController.controlCenterInfo.nowPlayingInfo!["MPNowPlayingInfoPropertyElapsedPlaybackTime"] = ViewController.player.currentTime().seconds
                return .success
            } else if ViewController.playbackControllerState == .playing{
                return .success
            } else {
                return .commandFailed
            }
        }
        ViewController.controlCenter.pauseCommand.addTarget {_ in
            if ViewController.playbackControllerState == .playing {
                self.pause()
                ViewController.controlCenterInfo.nowPlayingInfo!["MPNowPlayingInfoPropertyElapsedPlaybackTime"] = ViewController.player.currentTime().seconds
                return .success
            } else if ViewController.playbackControllerState == .paused{
                return .success
            } else {
                return .commandFailed
            }
        }
        ViewController.controlCenter.nextTrackCommand.addTarget {_ in
            if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
                self.advance()
                return .success
            } else {
                return .commandFailed
            }
        }
        ViewController.controlCenter.previousTrackCommand.addTarget {_ in
            if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
                self.reverse()
                return .success
            } else {
                return .commandFailed
            }
        }
        ViewController.controlCenter.seekForwardCommand.addTarget {_ in
            return .commandFailed
        }
        ViewController.controlCenter.seekBackwardCommand.addTarget {_ in
            return .commandFailed
        }
        ViewController.controlCenter.changePlaybackPositionCommand.addTarget {_ in
            if ViewController.controlCenterInfo.nowPlayingInfo != nil {
                ViewController.controlCenterInfo.nowPlayingInfo!["MPNowPlayingInfoPropertyElapsedPlaybackTime"] = ViewController.player.currentTime().seconds
            }
            return .commandFailed
        }
        //        SFX.testVoices()
        //        Uncomment to reset user settings
        //
        //        ViewController.defaults.set(0, forKey: "artwork")
        //        ViewController.defaults.set(0, forKey: "appearance")
        //        ViewController.defaults.set(0, forKey: "qboot")
        //        ViewController.defaults.set(0, forKey: "deepwave")
        touchBar = bar
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.myKeyDown(with: $0)
            return $0
        }
        updateAppearance()
        allLights = [frequencyControllerLight_new,
                     frequencyControllerLight_tune,
                     frequencyControllerLight_stream,
                     frequencyControllerLight_memory,
                     playbackControllerLight_play,
                     playbackControllerLight_pause,
                     playbackControllerLight_error,
                     playbackControllerLight_loading,
                     playbackControllerLight_sleep,
                     playbackControllerLight_deepwave,
                     playbackControllerLight_stream]
        ViewController.configFilePath = FileManager().homeDirectoryForCurrentUser.appendingPathComponent("Music/Radio Automne")
        if let a = ViewController.configFilePath {
            if !ViewController.fm.fileExists(atPath: a.path) {
                try? ViewController.fm.createDirectory(atPath: a.path, withIntermediateDirectories: true, attributes: nil)
                let fp = a.appendingPathComponent("config.json")
                let jsonData = try? JSONEncoder().encode(CustomFrequencies(frequencies: [Frequency(name: "", reliable: false, num: "", isNew: false, isStream: false, playlistID: "", streamURL: "", streamDescription: "")]))
                ViewController.fm.createFile(atPath: fp.path, contents: jsonData, attributes: nil)
                ViewController.configFilePath = fp
            } else {
                ViewController.configFilePath = a.appendingPathComponent("config.json")
            }
        }
        if ViewController.defaults.integer(forKey: "appearance") == 0 {
            ViewController.defaults.set(1, forKey: "appearance")
            ViewController.defaults.set(1, forKey: "deepwave_count")
            ViewController.defaults.set(2, forKey: "artwork")
        }
        if ViewController.defaults.integer(forKey: "server") == 0 {
            ViewController.defaults.set(1, forKey: "server")
        }
    }
    
    override var representedObject: Any? {
        didSet{ }
    }
    
    ///System
    func updateAppearance() {
        switch ViewController.defaults.integer(forKey: "appearance") {
        case 0,1:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_1")
            box.image = NSImage.init(named: "Box_1")
            standbyButton.image = NSImage.init(named: "OnStandby_1")
        case 2:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_1")
            box.image = NSImage.init(named: "Box_2")
            standbyButton.image = NSImage.init(named: "OnStandby_1")
        case 3:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_3")
            box.image = NSImage.init(named: "Box_3")
            standbyButton.image = NSImage.init(named: "OnStandby_3")
        case 4:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_3")
            box.image = NSImage.init(named: "Box_4")
            standbyButton.image = NSImage.init(named: "OnStandby_3")
        case 5:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_3")
            box.image = NSImage.init(named: "Box_5")
            standbyButton.image = NSImage.init(named: "OnStandby_5")
        case 6:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_6")
            box.image = NSImage.init(named: "Box_6")
            standbyButton.image = NSImage.init(named: "OnStandby_6")
        case 7:
            volumeKnob.image = NSImage.init(named: "VolumeKnob_1")
            box.image = NSImage.init(named: "Box_7")
            standbyButton.image = NSImage.init(named: "OnStandby_1")
        default: ()
        }
    }
    func myKeyDown(with event: NSEvent) {
        super.keyDown(with: event)
        hideImage()
        if event.keyCode == 0x7E && ViewController.inMenu //DOWN
        {
            tclear()
            ViewController.smenu = ViewController.smenu.downSel()
            tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true, noWipe: true)
        }
        else if event.keyCode == 0x7D && ViewController.inMenu //UP
        {
            tclear()
            ViewController.smenu = ViewController.smenu.upSel()
            tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true, noWipe: true)
        }
        else if event.keyCode == 0x7C //RIGHT
        {
            if ViewController.inMenu {
                tclear()
                ViewController.smenu = ViewController.smenu.increment([])
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true, noWipe: true)
            } else {
                if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
                    advance()
                }
            }
        }
        else if event.keyCode == 0x7B //LEFT
        {
            if ViewController.inMenu {
                tclear()
                ViewController.smenu = ViewController.smenu.decrement()
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true, noWipe: true)
                
            } else {
                if ViewController.systemStatus == .active && (ViewController.setFrequency == nil || !(ViewController.setFrequency?.isStream ?? true)){
                    reverse()
                }
            }
        }
        else if event.keyCode == 36  //RETURN
        {
            if ViewController.inMenu {
                saveDefaults()
            } else {
                if ViewController.systemStatus == .standby{
                    powerOn()
                } else if ViewController.systemStatus != .busy {
                    powerOff()
                }
            }
        }
        if event.keyCode == 49 { //SPACE
            if ViewController.systemStatus == .ready{
                play(from: ViewController.playbackIndex)
            }
            else if ViewController.playbackControllerState == .playing {
                pause()
            }
            else if ViewController.playbackControllerState == .paused {
                resume()
            }
        }
        else if event.keyCode == 12 { //Q
            exit(0)
        }
        else if event.keyCode == 14 { //E
            if ViewController.TSBP < 14{
                ViewController.TSBP += 1
            } else if ViewController.playbackControllerState == .playing{
                ViewController.TSBP = 0
                tclear()
                tprint(AutomneKeys.dedication, raw: true, noWipe: true)
            }
        }
        else if event.keyCode == 0 && ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{ //A
            let i = ViewController.selectedFrequencyIndex
            if i > 0 {
                switchFrequency(to: ViewController.retrievedFrequencies[i - 1], index: i - 1)
            }
        }
        else if event.keyCode == 2 && ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{ //D
            let i = ViewController.selectedFrequencyIndex
            if i < ViewController.retrievedFrequencies.count - 1 {
                switchFrequency(to: ViewController.retrievedFrequencies[i + 1], index: i + 1)
            }
        }
        else if event.keyCode == 1 && ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{ //S
            ViewController.player.pause()
            ViewController.mainDisplayState = .frequency
            let fr = ViewController.selectedFrequency!
            if fr.isStream! {
                self.startStream(frequency: fr)
            } else {
                self.retrieveTracks(frequency: fr)
            }
        }
        else {
            guard ViewController.selectedFrequencyIndex == 0 else { return }
            var k: Int? = nil
            switch event.keyCode {
            case 18...21:
                k = Int(event.keyCode - 17)
            case 19:
                k = 2
            case 20:
                k = 3
            case 21:
                k = 4
            case 23:
                k = 5
            case 22:
                k = 6
            case 26:
                k = 7
            case 28:
                k = 8
            case 25:
                k = 9
            case 29:
                k = 0
            case 51:
                k = 51
//            case let k:
//                print(k)
            default: ()
            }
            if let key = k {
                if key == 51 {
                    ViewController.demandFrequencyID = String(ViewController.demandFrequencyID.dropLast())
                } else {
                    ViewController.demandFrequencyID += String(key)
                }
                setFreqLabel(to: "ID: >\(ViewController.demandFrequencyID)")
            }
        }
    }
    func sendToGithub() {
        NSWorkspace.shared.open(URL(string: "https://github.com/Lesterrry/Radio-Automne")!)
    }
    func saveDefaults() {
        let log = ViewController.defaults.integer(forKey: "log") == 1
        ViewController.defaults.set(ViewController.smenu.elements[0].value, forKey: "artwork")
        ViewController.defaults.set(ViewController.smenu.elements[1].value, forKey: "appearance")
        ViewController.defaults.set(ViewController.smenu.elements[2].value, forKey: "qboot")
        ViewController.defaults.set(ViewController.smenu.elements[4].value, forKey: "server")
        ViewController.defaults.set(ViewController.smenu.elements[5].value, forKey: "log")
        ViewController.defaults.set(ViewController.smenu.elements[6].value, forKey: "narrator")
        ViewController.defaults.set(ViewController.smenu.elements[7].value, forKey: "deepwave_chance")
        ViewController.defaults.set(ViewController.smenu.elements[8].value, forKey: "deepwave_count")
        ViewController.inMenu = false
        trestore()
        if log { tprint("Configuration saved") }
        updateAppearance()
        ViewController.sleepTimer?.invalidate()
        if ViewController.smenu.elements[3].value != 0 && ViewController.systemStatus == .active{
            ViewController.sleepTimer = Timer.scheduledTimer(
                timeInterval: TimeInterval(ViewController.smenu.elements[3].value * 600),
                target: self,
                selector: #selector(self.sleep), userInfo: nil, repeats: false)
        }
        if ViewController.systemStatus == .active {
            checkAndInvokeImage()
        }
    }
    @objc func sleep() {
        powerOff()
        AutomneCore.notify(title: "🌌 Good night")
        AutomneCore.systemSleep()
    }
    func powerOn() {
        let log = ViewController.defaults.integer(forKey: "log") == 1
        for light in allLights {
            light.isHidden = false
        }
        tprint("AutomneOS \(ViewController.VERSION_NAME)", raw: true)
        tprint(appVersion ?? "", raw: true)
        glitchStripe.isHidden = false
        setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        TBLabel.stringValue = "AutomneOS " + ViewController.VERSION_NAME
        
        ViewController.ticker = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.tick), userInfo: nil, repeats: true)
        ViewController.mainDisplaySwitchTimer = Timer.scheduledTimer(
            timeInterval: 3.5,
            target: self,
            selector: #selector(self.mainDisplayTick), userInfo: nil, repeats: true)
        if ViewController.defaults.integer(forKey: "qboot") == 0{
            SFX.playSFX(sfx: SFX.Effects.powerOn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                for light in self.allLights {
                    light.isHidden = true
                }
                self.setPlaybackLabel(to: "Radio Automne")
                self.tprint(log ? "Loading mainframe..." : "Booting...")
            }
            if log {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.tprint("SUCCESS")
                    self.tprint("Making leaves yellow...")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                if log { self.tprint("SUCCESS") }
                self.setFreqLabel(to: "Configuring...")
                self.tprint("Configuring mod...")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                if log { self.tprint("SUCCESS") }
                self.setFreqLabel(to: "Configured")
                if log { self.tprint("Compiling 'Endless Autumn.scpt'...") }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.35) {
                self.tclear()
                self.tprint(self.fetchLogo, raw: true, noBreak: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                self.retrieveFrequencies()
            }
        } else {
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                for light in self.allLights {
                    light.isHidden = true
                }
                self.tprint("[QUICK BOOT]", raw: true)
                self.retrieveFrequencies()
            }
        }
        if appVersion != ViewController.defaults.string(forKey: "version"){
            ViewController.defaults.set(appVersion, forKey: "version")
            AutomneCore.systemSleepCheck()
        }
    }
    
    func powerOff() {
        ViewController.setFrequencyIndex = -1
        ViewController.setFrequency = nil
        ViewController.player = AVPlayer()
        TBLabel.stringValue = ""
        glitchStripe.isHidden = true
        removeImage()
        ViewController.sleepTimer?.invalidate()
        setSystemStatus(to: .standby)
        setPlaybackControllerState(to: .none)
        setFreqLabel(to: "")
        setPlaybackLabel(to: "")
        ViewController.inMenu = false
        for light in allLights{
            light.isHidden = true
        }
        terminal.stringValue = ""
        ViewController.inMenu = false
        SFX.shutUp(speaker: true)
        ViewController.ticker.invalidate()
        ViewController.mainDisplaySwitchTimer.invalidate()
    }
    
    @objc func tick() {
        let sv = ViewController.savedVolume
        let vol = AutomneCore.getSystemVolume()
        if vol != sv && !ViewController.firstCall{
            self.rotate(
                from: ViewController.volumeKnobAngle,
                by: CGFloat(((abs(vol - ViewController.savedVolume)) / 6) * (sv - vol > 0 ? 1 : -1)), timeToRotate: 0.5)
        }
        else if ViewController.firstCall{
            ViewController.firstCall = false
        }
        ViewController.savedVolume = vol
        
        if ViewController.terminalImageLeftTicks == 0 && terminalImage.isHidden{
            showImage()
        } else if ViewController.terminalImageLeftTicks > 0 {
            ViewController.terminalImageLeftTicks -= 1
        }
        if ViewController.terminalStripeLeftTicks == 0 {
            stripe()
            ViewController.terminalStripeLeftTicks = 15
        } else if ViewController.terminalStripeLeftTicks > 0 {
            ViewController.terminalStripeLeftTicks -= 1
        }
        
        if ViewController.playbackControllerState == .playing{
            let b = playbackControllerLight_play.isHidden
            if ViewController.player.reasonForWaitingToPlay != nil {
                ViewController.player.playImmediately(atRate: 1.0)
                playbackControllerLight_loading.isHidden = false
                if ViewController.playerWaitingTimeoutTimer == nil
                    || !ViewController.playerWaitingTimeoutTimer.isValid{
                    ViewController.playerWaitingTimeoutTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.playerWaitingTimeout), userInfo: nil, repeats: false)
                }
            } else {
                ViewController.playerWaitingTimeoutTimer?.invalidate()
                playbackControllerLight_loading.isHidden = true
                playbackControllerLight_deepwave.isHidden = !(ViewController.currentTrack?.deepWave ?? false)
                if ViewController.sleepTimer != nil && ViewController.sleepTimer.isValid {
                    playbackControllerLight_sleep.isHidden = false
                }
                else{
                    playbackControllerLight_sleep.isHidden = true
                }
                if ViewController.setFrequency != nil && ViewController.setFrequency!.isStream ?? true {
                    playbackControllerLight_stream.isHidden = false
                } else {
                    playbackControllerLight_play.isHidden = !b
                }
            }
        }
        
        if ViewController.systemStatus == .active && ViewController.playbackControllerState != .error && ViewController.mainDisplayState == .time{
            var stdv: String?
            if ViewController.sleepTimer != nil && ViewController.sleepTimer.isValid{
                let c = Int(floor(Date.init().distance(to: ViewController.sleepTimer.fireDate)))
                stdv = String(c / 60) + ":" + String(c % 60)
            }
            let tail = (stdv == nil ? "" : ("    Sleep: " + stdv!))
            if ViewController.setFrequency != nil && (ViewController.setFrequency?.isStream)! {
                self.setPlaybackLabel(to: "Live " + tail)
            }
            else {
                let sec = Int(ViewController.player.currentTime().seconds)
                let dur = (ViewController.currentTrack!.duration ?? 600000) / 1000
                let val = dur - sec
                let pSec = val % 60
                let muzzle = "   -" + String(val / 60) + ":"
                let withers = (pSec < 10 ? ("0" + String(pSec)) : String(pSec))
                self.setPlaybackLabel(to: muzzle + withers + tail)
            }
        }
    }
    
    func setSystemStatus(to: AutomneProperties.SystemStatus) {
        ViewController.systemStatus = to
        switch to {
        case .active, .ready, .unset:
            statusLight.image = NSImage.init(named: "StatusLight_ready")
            TBStatusLight.image = NSImage.init(named: "StatusLight_ready")
        case .error:
            statusLight.image = NSImage.init(named: "StatusLight_error")
            TBStatusLight.image = NSImage.init(named: "StatusLight_error")
            setFreqLabel(to: "ERR")
            setPlaybackLabel(to: "ERR")
            AutomneCore.notify(title: "🆘 System error encountered")
        default:
            statusLight.image = NSImage.init(named: "StatusLight_" + to.rawValue)
            TBStatusLight.image = NSImage.init(named: "StatusLight_" + to.rawValue)
        }
    }
    
    ///Volume knob
    func rotate(from: CGFloat, by: CGFloat, timeToRotate: Double) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            ViewController.volumeKnobAngle = from + by
        })
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = from
        rotateAnimation.byValue = by
        rotateAnimation.duration = timeToRotate
        rotateAnimation.repeatCount = 1
        rotateAnimation.fillMode = CAMediaTimingFillMode.both
        rotateAnimation.isRemovedOnCompletion = false
        
        volumeKnob.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        volumeKnob.layer?.position = CGPoint(x: volumeKnob.frame.origin.x + volumeKnob.frame.width / 2,
                                             y: volumeKnob.frame.origin.y + volumeKnob.frame.height / 2)
        volumeKnob.layer?.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    ///Playback Controller
    @objc func playerWaitingTimeout() {
        let r = ViewController.player.reasonForWaitingToPlay
        if r != nil{
            if AutomneAxioms.isConnectedToNetwork(){
                AutomneCore.notify(title: "⚠️ Couldn't play")
                tprint("WARN1: AVP_W, " + r!.rawValue)
                tprint("Couldn't play")
                if !(ViewController.setFrequency?.isStream ?? true) {
                    ViewController.player.cancelPendingPrerolls()
                    advance()
                }
            }
            else {
                tprint("ERR11: AVP_W, " + r!.rawValue)
                tprint("Check connection")
                ViewController.player = AVPlayer()
                setPlaybackControllerState(to: .error)
            }
        }
    }
    func setPlaybackControllerState(to: AutomneProperties.PlaybackControllerState, isStream: Bool = false) {
        switch to {
        case .playing:
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_error.isHidden = true
            ViewController.controlCenterInfo.playbackState = .playing
        case .paused:
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = false
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = true
            playbackControllerLight_deepwave.isHidden = true
            ViewController.controlCenterInfo.playbackState = .paused
        case .loading:
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = false
            playbackControllerLight_error.isHidden = true
            playbackControllerLight_deepwave.isHidden = true
        case .error:
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = false
            playbackControllerLight_deepwave.isHidden = true
            AutomneCore.notify(title: "🆘 Playback error encountered")
            ViewController.controlCenterInfo.playbackState = .stopped
            ViewController.controlCenterInfo.nowPlayingInfo = .none
            removeImage()
        case .none:
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = true
            playbackControllerLight_deepwave.isHidden = true
            ViewController.controlCenterInfo.playbackState = .stopped
            ViewController.controlCenterInfo.nowPlayingInfo = .none
        }
        ViewController.playbackControllerState = to
        playbackControllerLight_stream.isHidden = !isStream
    }
    
    ///Player
    @objc func playerDidFinishPlaying(sender: Notification) {
        advance()
    }
    func advance() {
        setSystemStatus(to: .busy)
        if ViewController.playbackIndex < ViewController.playableQueue.count - 1{
            play(from: ViewController.playbackIndex + 1)
        } else {
            ViewController.playableQueue.shuffle()
            tprint("Stream was mixed (1)")
            play(from: 0)
        }
    }
    func reverse() {
        setSystemStatus(to: .busy)
        if ViewController.playbackIndex > 0 {
            play(from: ViewController.playbackIndex - 1)
        } else if ViewController.currentTrack != nil {
            ViewController.playableQueue.shuffle()
            tprint("Stream was mixed (2)")
            play(from: 0)
        }
    }
    func play(from: Int = 0, init: Bool = false) {
        var url: URL
        let isStream = (ViewController.setFrequency?.isStream) ?? false
        let track: Track?
        if isStream {
            track = nil
            url = URL(string: (ViewController.setFrequency?.streamURL!)!)!
            setSystemStatus(to: .active)
            ViewController.currentTrack = nil
            tclear()
            tprint("", raw: true)
            tprint("", raw: true)
            tprint(" ***", raw: true)
            tprint((ViewController.setFrequency?.streamDescription)!, raw: true)
            tprint(" ***", raw: true)
            removeImage()
            ViewController.controlCenterInfo.nowPlayingInfo = [
                "mediaType": MPMediaType.anyAudio,
                "albumTitle": "Live",
                "artist": "FM " + ((ViewController.setFrequency?.num) ?? "unknown"),
                "title": (ViewController.setFrequency?.name) ?? "Unknown",
                MPNowPlayingInfoPropertyIsLiveStream: 1.0
            ]
        } else {
            track = ViewController.playableQueue[from]
            ViewController.currentTrack = track
            if `init` {
                tclear()
                tprint("", raw: true)
                tprint("", raw: true)
                tprint(" ***", raw: true)
                tprint(ViewController.playlist!.description!, raw: true)
                tprint(" ***", raw: true)
            } else {
                let e = AutomneAxioms.emojis.randomElement()!
                tprint(e + " " + (AutomneAxioms.messages.randomElement() ?? "Playing..."), raw: true, addBreak: true)
                AutomneCore.notify(title: e + (track!.user?.username ?? "Unknown") + " in our broadcast",
                                   subtitle: (track!.deepWave! ? "🌀 " : "") + (track!.title ?? "Unknown"))
            }
            setPlaybackControllerState(to: .loading)
            ViewController.playbackIndex = from
            let url = URL(string: track!.media!.transcodings![0].url!
                + AutomneAxioms.SCTailQueue[0]
                + AutomneKeys.scKey)!
            AF.request(url).response { response in
                let decoder = JSONDecoder()
                switch response.result {
                    case .success( _):
                        guard let data = response.data else {
                            self.tprint("ERROR122: No data from url callback")
                            self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                            SFX.shutUp()
                            return
                        }
                        let obj = try! decoder.decode(TrackStreamURLCallback.self, from: data)
                        let playerItem = AVPlayerItem.init(url: URL(string: obj.url!)!)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)),
                                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                               object: playerItem)
                        ViewController.player = AVPlayer.init(playerItem: playerItem)
                        ViewController.player.volume = 1.0
                        
                        if ViewController.defaults.integer(forKey: "narrator") == 1 && !isStream {
                            let a = SFX.composeAndSpeak(track: (track!.title ?? "unknown"), artist: (track!.user?.username) ?? "unknown")
                            if a.0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: { ViewController.player.play() })
                            } else {
                                ViewController.player.play()
                                if ViewController.defaults.integer(forKey: "log") == 1 {
                                    self.tprint("WARN4: (synth) \(a.1 ?? "nil")")
                                }
                            }
                        } else {
                            ViewController.player.play()
                        }
                        
                        let b = ViewController.defaults.integer(forKey: "deepwave_chance")
                        if b != 0 && !isStream && !(track!.deepWave ?? false) {
                            let c = Int.random(in: 0...(10 - (b * 2)))
                            if c == 0 || c == 1 {
                                self.initDeepwave(with: track!, count: ViewController.defaults.integer(forKey: "deepwave_count"), add: true)
                            }
                        }
                        ViewController.mainDisplayState = .frequency
                        self.setPlaybackControllerState(to: .playing)
                        if ViewController.player.error != nil {
                            self.setSystemStatus(to: .error)
                            self.setPlaybackControllerState(to: .error)
                            self.tprint("ERROR7: " + ViewController.player.error!.localizedDescription)
                        }
                    case .failure(let error):
                        self.tprint("ERROR1: " + error.localizedDescription)
                        self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                        SFX.shutUp()
                }
                
            }
            self.setSystemStatus(to: .active)
            self.playbackControllerLight_deepwave.isHidden = !track!.deepWave!
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.checkAndInvokeImage()
            })
            
            let a = ViewController.controlCenterInfo.nowPlayingInfo?["artwork"]
            ViewController.controlCenterInfo.nowPlayingInfo = [
                "mediaType": MPMediaType.music,
                "albumTitle": (ViewController.setFrequency?.name) ?? "Deepwave",
                "artist": (track?.user?.username) ?? "Unknown",
                "title": ((track!.deepWave ?? false) ? "🌀 " : "") + ((track?.title) ?? "Unknown"),
                "playbackDuration": TimeInterval(exactly: track!.duration! / 1000)!,
                "bookmarkTime": TimeInterval(exactly: 0.0)!,
                MPNowPlayingInfoPropertyIsLiveStream: 0.0,
            ]
            ViewController.controlCenterInfo.nowPlayingInfo!["artwork"] = a ?? .none
        }
        
    }
    
    func pause(){
        ViewController.player.pause()
        ViewController.sleepTimer?.invalidate()
        setSystemStatus(to: .active)
        setPlaybackControllerState(to: .paused)
    }
    
    func resume(){
        ViewController.player.play()
        if ViewController.player.error != nil{
            setSystemStatus(to: .error)
            setPlaybackControllerState(to: .error)
            tprint("ERROR9: " + ViewController.player.error!.localizedDescription)
        }
        else{
            setSystemStatus(to: .active)
            setPlaybackControllerState(to: .playing)
            ViewController.controlCenterInfo.playbackState = .playing
        }
    }
    
    ///API
    func initDeepwave(with: Track, count: Int = -1, add: Bool = false) {
        let url = URL(
            string: with.uri! + AutomneAxioms.SCDeepWaveQueue + AutomneAxioms.SCTailQueue[0] + AutomneKeys.scKey
            )!
        AF.request(url).response { response in
            switch response.result {
            case .success( _):
                do{
                    let decoder = JSONDecoder()
                    
                    guard var obj = try? decoder.decode([Track].self, from: response.data!) else {
                        throw NSError()
                    }
                    for i in 0..<obj.count{
                        obj[i].deepWave = true
                    }
                    obj = AutomneAxioms.uniq(source: obj, from: ViewController.playableQueue)
                    if add {
                        let o: [Track]
                        if obj.count > count {
                            o = Array(obj.shuffled()[0...count - 1])
                        } else {
                            o = obj.shuffled()
                        }
                        self.fillQueue(with: o, insert: ViewController.playbackIndex + 1, shuffle: false)
                    } else {
                        self.fillQueue(with: obj, append: false)
                        self.tprint(String(obj.count) + " tracks by DeepWave")
                        ViewController.deepWaveInitiator = with
                        ViewController.setFrequencyIndex = -1
                        ViewController.setFrequency = nil
                        ViewController.playbackIndex = 0
                        
                        self.setFreqLight(to: .unknown)
                        self.play(from: 0, init: false)
                    }
                }
                catch{
                    self.tprint("WARN2: Couldn't init DeepWave")
                    SFX.shutUp()
                }
                
            case .failure(let error):
                self.tprint("WARN3 (DeepWave): " + error.localizedDescription)
                SFX.shutUp()
            }
        }
    }
    
    func retrieveFrequencies() {
        ViewController.retrievedFrequencies = [Frequency(name: ViewController.freqDemandPlaceholder, reliable: nil, num: nil, isNew: nil, isStream: false, playlistID: nil, streamURL: nil, streamDescription: nil)]
        let log = (ViewController.defaults.integer(forKey: "log") == 1) ? true : false
        var custom: CustomFrequencies? = nil
        if let a = ViewController.configFilePath {
            custom = try? JSONDecoder().decode(CustomFrequencies.self, from: FileHandle(forReadingFrom: a).readDataToEndOfFile()).reliable()
            if let c = custom, let cf = c.frequencies, cf.count > 0 {
                if log { tprint("From memory: \(cf.count)") }
                ViewController.retrievedFrequencies.append(contentsOf: cf)
            }
        } else {
            tprint("WARN6: Memory error")
        }
        SFX.playSFX(sfx: SFX.Effects.radioSetup)
        tprint(log ? "Connecting via \((ViewController.defaults.integer(forKey: "server") == 1) ? "Silverwing" : "Sprint")" : "Please wait...")
        setFreqLabel(to: "Retrieving...")
        self.setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        self.setPlaybackControllerState(to: .none)
        let a = ViewController.defaults.integer(forKey: "server")
        let url = URL(
            string: AutomneAxioms.firstResponderNoseQueue[a - 1] +
                AutomneKeys.firstResponderKey[a - 1]
            )!
        AF.request(url).response { response in
            switch response.result {
            case .success( _):
                do{
                    let decoder = JSONDecoder()
                    let obj = try decoder.decode(FirstResponderAnswer.self, from: response.data!)
                    AutomneKeys.scKey = obj.scKey!
                    ViewController.retrievedFrequencies.append(contentsOf: obj.frequencies!)
                    let task = {
                        self.switchFrequency(to: ViewController.retrievedFrequencies[1], index: 1)
                        if log { self.tprint("Retrieved " + String(ViewController.retrievedFrequencies.count) + " frequencies") }
                        self.tprint(obj.narratives![0], raw: true)
                        self.TBLabel.stringValue = obj.narratives![0]
                        AutomneAxioms.messages.append(contentsOf: obj.narratives ?? [])
                        self.tprint("Ready")
                        if obj.version != self.appVersion && !(self.appVersion?.contains("beta"))!{
                            self.tprint("Update to v\(obj.version ?? "?") at automne.aydar.media/release")
                        }
                        self.setSystemStatus(to: .unset)
                        SFX.shutUp()
                        DispatchQueue.main.asyncAfter(deadline: .now() +  1){
                            if ViewController.defaults.integer(forKey: "narrator") == 1 {
                                SFX.speakWelcome()
                            }
                        }
                    }
                    if ViewController.defaults.integer(forKey: "qboot") == 0{
                        DispatchQueue.main.asyncAfter(deadline: .now() +  2){
                            task()
                        }
                    } else {
                        task()
                    }
                }
                catch {
                    self.serveOfflineMode()
                }
                
            case .failure( _):
                self.serveOfflineMode()
            }
        }
    }
    
    func serveOfflineMode() {
        self.switchFrequency(to: ViewController.retrievedFrequencies[0], index: 0)
        self.tprint("WARN5: First responder failure. Try updating or switching server.")
        self.TBLabel.stringValue = "No FR mode"
        self.setSystemStatus(to: .unset)
        SFX.shutUp()
    }
    
    func serveNoFreq(_ with: Frequency) {
        self.tprint("This frequency does not exist")
        self.setSystemStatus(to: .unset)
        self.setFreqLight(to: .unknown, new: with.isNew ?? false, memory: with.reliable ?? false)
        SFX.shutUp()
    }
    
    func startStream(frequency: Frequency) {
        if ViewController.defaults.integer(forKey: "log") == 1 { self.tprint("Ready to stream") }
        removeImage()
        self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
        self.setPlaybackLabel(to: "Ready")
        SFX.shutUp()
        self.setFreqLight(to: .tuned, new: frequency.isNew!, stream: true)
        ViewController.setFrequencyIndex = ViewController.selectedFrequencyIndex
        ViewController.setFrequency = frequency
        setPlaybackControllerState(to: .none)
        removeImage()
    }
    
    func retrieveTracks(frequency: Frequency){
        let playlistID = frequency.name == ViewController.freqDemandPlaceholder ? ViewController.demandFrequencyID : frequency.playlistID!
        guard playlistID != "" else { return }
        removeImage()
        let log = (ViewController.defaults.integer(forKey: "log") == 1) ? true : false
        ViewController.sleepTimer?.invalidate()
        setPlaybackLabel(to: "")
        setFreqLight(to: .tuning, new: frequency.isNew ?? false, memory: frequency.reliable ?? false)
        SFX.playSFX(sfx: SFX.Effects.radioSetup)
        setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        setPlaybackControllerState(to: .none)
        if log { tprint("Retrieving audio data...") }
        ViewController.demandFrequencyID = ""
        let url = URL(
            string: AutomneAxioms.SCNoseQueue
                + AutomneAxioms.SCPlaylistQueue
                + playlistID
                + AutomneAxioms.SCTailQueue[0]
                + AutomneKeys.scKey
            )!
        
        AF.request(url).response { response in
            switch response.result {
            case .success( _):
                do {
                    let decoder = JSONDecoder()
                    guard let data = response.data else {
                        self.serveNoFreq(frequency)
                        return
                    }
                    let obj = try decoder.decode(Playlist.self, from: data)
                    let task = {
                        if obj.tracks != nil {
                            var ids = [""]
                            var index = 0
                            for i in 0...obj.tracks!.count - 1 {
                                ids[index].append(String(obj.tracks![i].id!) + ",")
                                if i % 50 == 0 {
                                    ids.append("")
                                    index += 1
                                }
                            }
                            let semaphore = DispatchSemaphore(value: 1)
                            var tracks: [Track] = []
                            DispatchQueue.global(qos: .userInitiated).async {
                                for i in 0...ids.count - 1 {
                                    let trurl = URL(
                                    string: AutomneAxioms.SCNoseQueue
                                        + AutomneAxioms.SCTracksQueue
                                        + ids[i]
                                        + AutomneAxioms.SCTailQueue[1]
                                        + AutomneKeys.scKey
                                    )!
                                    AF.request(trurl).response { trresponse in
                                        switch trresponse.result {
                                            case .success( _):
                                                guard let trdata = trresponse.data else {
                                                    self.serveNoFreq(frequency)
                                                    return
                                                }
                                                let trobj = try! decoder.decode([Track].self, from: trdata)
                                                tracks.append(contentsOf: trobj)
                                            case .failure(let error):
                                                self.tprint("ERROR1: " + error.localizedDescription)
                                                self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                                                SFX.shutUp()
                                        }
                                        semaphore.signal()
                                    }
                                    semaphore.wait()
                                }
                                DispatchQueue.main.async {
                                    self.fillQueue(with: tracks, shuffle: true)
                                    //MARK: Это костыль, переписать playable queue
                                    ViewController.playlist = obj
                                    self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
                                    self.setPlaybackLabel(to: "Ready")
                                    SFX.shutUp()
                                    if frequency.name == ViewController.freqDemandPlaceholder {
                                        self.setFreqLabel(to: obj.title ?? "Unknown")
                                    }
                                    self.setFreqLight(to: .tuned, new: frequency.isNew ?? false, memory: frequency.reliable ?? false)
                                    ViewController.setFrequencyIndex = ViewController.selectedFrequencyIndex
                                    ViewController.setFrequency = frequency
                                }
                            }
                        } else {
                            self.serveNoFreq(frequency)
                        }
                    }
                    if ViewController.defaults.integer(forKey: "qboot") == 0{
                        DispatchQueue.main.asyncAfter(deadline: .now() +  2){
                            task()
                        }
                    } else {
                        task()
                    }
                }
                catch {
                    self.tprint("ERROR2: " + error.localizedDescription)
                    self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                    SFX.shutUp()
                }
                
            case .failure(let error):
                self.tprint("ERROR1: " + error.localizedDescription)
                self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                SFX.shutUp()
            }
        }
    }
    
    ///Playback queue
    func fillQueue(with: [Track], append: Bool = false, insert: Int = -1, shuffle: Bool = true){
        if append {
            ViewController.playableQueue.append(contentsOf: with)
        } else if insert != -1 {
            ViewController.playableQueue.insert(contentsOf: with, at: insert)
        } else {
            (ViewController.playableQueue = with)
        }
        if shuffle { ViewController.playableQueue.shuffle() }
    }
    
    ///Frequency controller
    func switchFrequency(to: Frequency, index: Int){
        ViewController.selectedFrequency = to
        ViewController.selectedFrequencyIndex = index
        ViewController.demandFrequencyID = ""
        frequencyControllerLabel.stringValue = to.name
        setFreqLight(to: (to.name != ViewController.freqDemandPlaceholder && index == ViewController.setFrequencyIndex) ? .tuned : .unknown, new: to.isNew ?? false, stream: to.isStream ?? false, memory: to.reliable ?? false)
    }
    func setFreqLabel(to: String){
        frequencyControllerLabel.stringValue = to
    }
    func setFreqLight(to: AutomneProperties.FrequencyControllerState, new: Bool = false, stream: Bool = false, memory: Bool = false){
        switch to {
        case .unknown:
            frequencyControllerLight_tune.isHidden = true
        case .tuning:
            frequencyControllerLight_tune.isHidden = false
            frequencyControllerLight_tune.image = NSImage.init(named: "FreqContLight_tuning")
        case .tuned:
            frequencyControllerLight_tune.isHidden = false
            frequencyControllerLight_tune.image = NSImage.init(named: "FreqContLight_tuned")
        }
        frequencyControllerLight_new.isHidden = !new
        frequencyControllerLight_stream.isHidden = !stream
        frequencyControllerLight_memory.isHidden = !memory
    }
    
    ///Main display
    enum MainDisplayState{
        case song
        case artist
        case time
        case frequency
    }
    
    func setPlaybackLabel(to: String){
        mainLabel.stringValue = to
    }
    
    @objc func mainDisplayTick(){
        if ViewController.systemStatus == .active{
            let isStream = (ViewController.setFrequency?.isStream) ?? false
            let fi = (isStream ? ViewController.streamStates : ViewController.states).firstIndex(of: ViewController.mainDisplayState) ?? 0
            ViewController.mainDisplayState =
                (isStream ? ViewController.streamStates : ViewController.states)[fi == (isStream ? ViewController.streamStates.count : ViewController.states.count) - 1 ? 0 : fi + 1]
            switch ViewController.mainDisplayState {
            case .song:
                setPlaybackLabel(to: isStream ? ("    FM " + ((ViewController.setFrequency?.num) ?? "No number")): (ViewController.currentTrack!.title ?? "Unknown title"))
            case .artist:
                setPlaybackLabel(to: "By " + (ViewController.currentTrack!.user?.username ?? "unknown artist"))
            case .frequency:
                let label = ViewController.setFrequencyIndex == 0 ? "On demand" : (isStream ? (ViewController.setFrequency?.name)! : (ViewController.setFrequencyIndex == -1 ? ("From: " + (ViewController.deepWaveInitiator?.title ?? "unknown")) : (ViewController.setFrequency!.name)))
                setPlaybackLabel(to: label)
            default: ()
            }
        }
    }
    
    ///Terminal
    func tclear(cache: Bool = false){
        cache ? ViewController.terminalCache = terminal.stringValue : ()
        hideImage()
        terminal.stringValue = ""
    }
    func trestore(){
        hideImage()
        if ViewController.terminalCache != "" { terminal.stringValue = ViewController.terminalCache }
    }
    func tprint(_ item: String, raw: Bool = false, noBreak: Bool = false, noWipe: Bool = false, addBreak: Bool = false){
        hideImage()
        let key = raw ? 26 : 25
        if item.count > key && !noBreak{
            var s = item
            for i in 1...item.count / key {
                s.insert(contentsOf: raw ? "\n" : "\n  ", at: s.index(s.startIndex, offsetBy: i * key))
            }
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + s + "\n"
        } else {
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + item + "\n" + (addBreak ? "\n" : "")
        }
        let o = terminal.stringValue.components(separatedBy: .newlines)
        if o.count > 10 && !noWipe{
            var n = ""
            for s in 5...o.count - 2{
                n.append(o[s] + "\n" )
            }
            n.append(o[o.count - 1])
            terminal.stringValue = n
        }
    }
    
    ///Images
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func removeImage(){
        terminalImage.image = nil
        ViewController.terminalImagePlaylistServed = false
        if ViewController.controlCenterInfo.nowPlayingInfo != nil {
            ViewController.controlCenterInfo.nowPlayingInfo!["artwork"] = .none
        }
    }
    func hideImage(){
        terminalImage.isHidden = true
        ViewController.terminalImageLeftTicks = 5
    }
    func showImage(){
        terminalImage.isHidden = false
    }
    func checkAndInvokeImage(){
        if ViewController.currentTrack != nil && !ViewController.inMenu{
            switch ViewController.defaults.integer(forKey: "artwork") {
            case 0:
                self.removeImage()
            case 1:
                if ViewController.currentTrack!.artwork_url != nil {
                    self.loadImage(from: URL(string: ((ViewController.currentTrack!.artwork_url)?.replacingOccurrences(of: "large", with: "t500x500"))!)!)
                } else {
                    self.removeImage()
                }
            case 2:
                if ViewController.playlist?.artwork_url != nil && !ViewController.terminalImagePlaylistServed{
                    self.loadImage(from: URL(string: (ViewController.playlist?.artwork_url!.replacingOccurrences(of: "large", with: "t500x500"))!)!)
                    ViewController.terminalImagePlaylistServed = true
                }
            default: ()
            }
        }
    }
    func loadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                self.tprint("ERROR: Fail loading artwork"); self.terminalImage.image = nil
                return
            }
            DispatchQueue.main.async {
                let image = NSImage(data: data)
                self.terminalImage.image = image
                let CCArtwork = MPMediaItemArtwork.init(boundsSize: image!.size, requestHandler: { (size) -> NSImage in
                    return image!
                })
                ViewController.controlCenterInfo.nowPlayingInfo?["artwork"] = CCArtwork
            }
        }
    }
    
    
    func stripe() {
        if ViewController.systemStatus == .active
            || ViewController.systemStatus == .ready{
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.byValue = -170.0
            animation.duration = 3.0
            animation.repeatCount = 1
            animation.isRemovedOnCompletion = true
            glitchStripe.layer?.add(animation, forKey: nil)
        }
    }
}
