//
//  ViewController.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Cocoa
import Alamofire
import AVFoundation
import AudioToolbox

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
    
    //*********************************************************************
    //OUTLETS
    //*********************************************************************
    @IBOutlet var bar: NSTouchBar!
    @IBOutlet weak var terminalImage: NSImageView!
    @IBOutlet weak var standbyButton: NSButton!
    @IBOutlet weak var box: NSImageView!
    @IBOutlet weak var mainLabel: NSTextField!
    @IBOutlet weak var TBLabel: NSTextField!
    @IBOutlet weak var repeatStatusLight: NSImageView!
    @IBOutlet weak var frequencyControllerLabel: NSTextField!
    @IBOutlet weak var volumeKnob: NSImageView!
    @IBOutlet weak var statusLight: NSImageView!
    @IBOutlet weak var TBStatusLight: NSImageView!
    @IBAction func pauseClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .playing {
            pause()
        }
    }
    @IBOutlet weak var terminal: NSTextField!
    @IBOutlet weak var manual: NSImageView!
    @IBOutlet weak var frequencyControllerLight_tune: NSImageView!
    @IBOutlet weak var frequencyControllerLight_new: NSImageView!
    @IBOutlet weak var glitchStripe: NSImageView!
    @IBOutlet weak var playbackControllerLight_play: NSImageView!
    @IBOutlet weak var playbackControllerLight_sleep: NSImageView!
    @IBOutlet weak var playbackControllerLight_pause: NSImageView!
    @IBOutlet weak var playbackControllerLight_loading: NSImageView!
    @IBOutlet weak var playbackControllerLight_error: NSImageView!
    var allLights: [NSImageView] = []
    
    //*********************************************************************
    //ACTIONS
    //*********************************************************************
    ///Frequency Controller
    @IBAction func freqControlUpClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            let i = ViewController.selectedFrequencyIndex
            if i < ViewController.retrievedFrequencies.count - 1 {
                switchFrequency(to: ViewController.retrievedFrequencies[i + 1], index: i + 1)
            }
        }
    }
    @IBAction func freqControlDownClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            let i = ViewController.selectedFrequencyIndex
            if i > 0 {
                switchFrequency(to: ViewController.retrievedFrequencies[i - 1], index: i - 1)
            }
        }
    }
    @IBAction func freqControlSetClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy && ViewController.systemStatus != .standby{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            ViewController.player.pause()
            ViewController.playlistArtworkServed = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.retrieveTracks(frequency: ViewController.selectedFrequency!)
            }
        }
    }
    
    ///System
    @IBAction func standbyClicked(_ sender: Any) {
        if ViewController.systemStatus == .standby{
            powerOn()
        }
        else if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            powerOff()
        }
    }
    
    ///Playback Controller
    @IBAction func playClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .ready ||
            ViewController.systemStatus == .playing {
            play(from: ViewController.playbackIndex, init: true)
        }
        else if ViewController.systemStatus == .paused {
            resume()
        }
    }
    @IBAction func setupClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            if ViewController.systemStatus != .error
                && ViewController.systemStatus != .standby
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
                        bounds: (1,4),
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
                        title: "[SAVE]",
                        value: 0,
                        bounds: (0,1),
                        isAction: true),
                    SetupMenu.SetupMenuElement(
                        title: "[SOURCE CODE]",
                        value: 0,
                        bounds: (0,1),
                        isAction: true)]
                ViewController.smenu = SetupMenu.get(for: els)
                tclear(cache: true)
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true)
                ViewController.inMenu = true
            }
        }
    }
    @IBAction func helpClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        manual.isHidden = false;
    }
    @IBAction func nextClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .playing {
            advance()
        }
    }
    @IBAction func prevClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .playing {
            reverse()
        }
    }
    @IBAction func shareClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .playing || ViewController.systemStatus == .paused{
            NSWorkspace.shared.open(URL(string: ViewController.playableQueue[ViewController.playbackIndex].permalink_url!)!)
        }
    }
    @IBAction func repeatClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            
            if ViewController.systemStatus != .standby{
                ViewController.`repeat` = !ViewController.`repeat`
                repeatStatusLight.isHidden = !ViewController.`repeat`
            }
        }
    }
    
    //*********************************************************************
    //VARS
    //*********************************************************************
    static var player : AVPlayer = AVPlayer()
    static var smenu = SetupMenu(elements: [], selected: 0)
    static var playableQueue: [Tracks] = []
    static var playlistArtwork = ""
    static var frequencyMessage = ""
    static var playlistArtworkServed = false
    static var playbackIndex = 0
    static var selectedFrequency: AutomneProperties.Frequency? = nil
    static var selectedFrequencyIndex = -1
    static var setFrequencyIndex = -1
    static var retrievedFrequencies: [AutomneProperties.Frequency] = []
    static var `repeat` = false;
    static var ticker: Timer!
    static var pauseLightBlinkTimer: Timer!
    static var mainDisplaySwitchTimer: Timer!
    static var sleepTimer: Timer!
    static var longTicker: Timer!
    static var terminalImageTimer: Timer!
    static var volumeKnobAngle: CGFloat = 0.0
    static var savedVolume = -1
    static var firstCall = true
    static var mainDisplayState = MainDisplayState.song
    static var inMenu = false
    static var description: String = ""
    static var latestVersion = ""
    static var TSBP = 0
    static var terminalCache = ""
    
    //*********************************************************************
    //CONSTS
    //*********************************************************************
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let defaults = UserDefaults.standard
    let fetchLogo = "### ### ### ### # #\n#   #    #  #   # #\n##  ###  #  #   ###\n#   #    #  #   # #\n#   ###  #  ### # #"
    static let states = [MainDisplayState.volume, MainDisplayState.frequency, MainDisplayState.song, MainDisplayState.artist, MainDisplayState.time]
    
    //*********************************************************************
    //FUNCTIONS
    //*********************************************************************
    
    override func viewDidAppear() {
        super.viewDidAppear()
        touchBar = bar
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.myKeyDown(with: $0)
            return $0
        }
        updateAppearance()
        allLights = [frequencyControllerLight_new,
                     frequencyControllerLight_tune,
                     repeatStatusLight,
                     playbackControllerLight_play,
                     playbackControllerLight_pause,
                     playbackControllerLight_error,
                     playbackControllerLight_loading,
                     playbackControllerLight_sleep]
        ViewController.ticker = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.tick), userInfo: nil, repeats: true)
        ViewController.mainDisplaySwitchTimer = Timer.scheduledTimer(
            timeInterval: 3.5,
            target: self,
            selector: #selector(self.mainDisplayTick), userInfo: nil, repeats: true)
        ViewController.longTicker = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.longTick), userInfo: nil, repeats: true)
    }
    
    override var representedObject: Any? {
        didSet{
            
        }
    }
    
    ///System
    func updateAppearance(){
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
        default: ()
        }
    }
    func myKeyDown(with event: NSEvent) {
        super.keyDown(with: event)
        hideImage()
        manual.isHidden = true
        if ViewController.inMenu{
            tclear()
            if event.keyCode == 0x7E //DOWN
            {
                ViewController.smenu = ViewController.smenu.downSel()
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true)
            }
            else if event.keyCode == 0x7D //UP
            {
                ViewController.smenu = ViewController.smenu.upSel()
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true)
            }
            else if event.keyCode == 0x7C //RIGHT
            {
                ViewController.smenu = ViewController.smenu.increment([{},{},{},{},saveDefaults,sendToGithub])
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true)
            }
            else if event.keyCode == 0x7B //LEFT
            {
                ViewController.smenu = ViewController.smenu.decrement()
                tprint(ViewController.smenu.getRaw(), raw: true, noBreak: true)
            }
        }
        if event.keyCode == 49{
            if ViewController.systemStatus == .ready{
                play(from: ViewController.playbackIndex)
            }
            else if ViewController.systemStatus == .playing {
                pause()
            }
            else if ViewController.systemStatus == .paused {
                resume()
            }
        }
        else if event.keyCode == 12{
            exit(0)
        }
        else if event.keyCode == 0{
            if ViewController.TSBP < 14{
                ViewController.TSBP += 1
            } else if ViewController.systemStatus == .playing{
                ViewController.TSBP = 0
                tclear()
                tprint(AutomneKeys.dedication, raw: true, noWipe: true)
            }
        }
    }
    func sendToGithub(){
        NSWorkspace.shared.open(URL(string: "https://github.com/Lesterrry/Radio-Automne")!)
    }
    func saveDefaults(){
        ViewController.defaults.set(ViewController.smenu.elements[0].value, forKey: "artwork")
        ViewController.defaults.set(ViewController.smenu.elements[1].value, forKey: "appearance")
        ViewController.defaults.set(ViewController.smenu.elements[2].value, forKey: "qboot")
        ViewController.inMenu = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.trestore()
            self.tprint("Configuration saved")
            self.updateAppearance()
        }
        ViewController.sleepTimer?.invalidate()
        if ViewController.smenu.elements[3].value != 0 && ViewController.systemStatus == .playing{
            ViewController.sleepTimer = Timer.scheduledTimer(
                timeInterval: TimeInterval(ViewController.smenu.elements[3].value * 600),
                target: self,
                selector: #selector(self.sleep), userInfo: nil, repeats: false)
        }
        checkAndInvokeImage()
    }
    @objc func sleep(){
        powerOff()
        AutomneCore.systemSleep()
    }
    func powerOn(){
        for light in allLights {
            light.isHidden = false
        }
        tprint("Booting AutomneOS", raw: true)
        tprint("v" + (appVersion ?? "?") + "...", raw: true)
        glitchStripe.isHidden = false
        setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        TBLabel.stringValue = "Booting..."
        
        if ViewController.defaults.integer(forKey: "qboot") == 0{
            SFX.playSFX(sfx: SFX.Effects.powerOn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                for light in self.allLights {
                    light.isHidden = true
                }
                self.setPlaybackLabel(to: "Radio Automne")
                self.tprint("Loading mainframe...")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tprint("SUCCESS")
                self.tprint("Making leaves yellow...")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.tprint("SUCCESS")
                self.setFreqLabel(to: "Configuring...")
                self.tprint("Configuring mod...")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                self.tprint("SUCCESS")
                self.setFreqLabel(to: "Configured")
                self.tprint("Compiling 'Endless Autumn.scpt'...")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.35) {
                self.tclear()
                self.tprint(self.fetchLogo, raw: true, noBreak: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                self.retrieveFrequencies(initial: true)
            }
        } else{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                for light in self.allLights {
                    light.isHidden = true
                }
                self.tprint("[QUICK BOOT]")
                self.retrieveFrequencies(initial: true)
            }
        }
    }
    
    func powerOff(){
        TBLabel.stringValue = ""
        glitchStripe.isHidden = true
        removeImage()
        ViewController.sleepTimer?.invalidate()
        setSystemStatus(to: .standby)
        setFreqLabel(to: "")
        setPlaybackLabel(to: "")
        ViewController.player.pause()
        for light in allLights{
            light.isHidden = true
        }
        ViewController.pauseLightBlinkTimer?.invalidate()
        terminal.stringValue = ""
        ViewController.inMenu = false
    }
    
    @objc func longTick(){
        stripe()
    }
    
    @objc func tick(){
        let sv = ViewController.savedVolume
        let vol = AutomneCore.getSystemVolume()
        if vol == -1{
            ViewController.ticker.invalidate()
        }
        else if vol != sv && !ViewController.firstCall{
            self.rotate(
                from: ViewController.volumeKnobAngle,
                by: CGFloat(((abs(vol - ViewController.savedVolume)) / 6) * (sv - vol > 0 ? 1 : -1)), timeToRotate: 0.5)
        }
        else if ViewController.firstCall{
            ViewController.firstCall = false
        }
        ViewController.savedVolume = vol
        
        if (ViewController.systemStatus == .playing || ViewController.systemStatus == .paused)
            && ViewController.mainDisplayState == .time{
            let sec = Int(ViewController.player.currentTime().seconds)
            let dur = (ViewController.playableQueue[ViewController.playbackIndex].duration ?? 600000) / 1000
            let val = dur - sec
            let pSec = val % 60
            
            var stdv: String?
            if ViewController.sleepTimer != nil && ViewController.sleepTimer.isValid{
                let c = Int(floor(Date.init().distance(to: ViewController.sleepTimer.fireDate)))
                stdv = String(c / 60) + ":" + String(c % 60)
            }
            let muzzle = "   -" + String(val / 60) + ":"
            let withers = (pSec < 10 ? ("0" + String(pSec)) : String(pSec))
            let tail = (stdv == nil ? "" : ("    Sleep: " + stdv!))
            self.setPlaybackLabel(to: muzzle + withers + tail)
        }
    }
    func setSystemStatus(to: AutomneProperties.SystemStatus){
        ViewController.systemStatus = to
        switch to {
        case .playing, .ready, .paused:
            statusLight.image = NSImage.init(named: "StatusLight_ready")
            TBStatusLight.image = NSImage.init(named: "StatusLight_ready")
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
    enum PlaybackControllerState{
        case playing
        case paused
        case loading
        case error
        case none
    }
    @objc func checkPlayLight(){
        if ViewController.systemStatus == .playing{
            playbackControllerLight_play.isHidden = false
            if ViewController.sleepTimer != nil && ViewController.sleepTimer.isValid{
                playbackControllerLight_sleep.isHidden = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.playbackControllerLight_play.isHidden = true
                self.playbackControllerLight_sleep.isHidden = true
            }
        }
    }
    func setPlaybackControllerState(to: PlaybackControllerState){
        switch to {
        case .playing:
            ViewController.pauseLightBlinkTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.checkPlayLight), userInfo: nil, repeats: true)
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = true
        case .paused:
            ViewController.pauseLightBlinkTimer?.invalidate()
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = false
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = true
        case .loading:
            ViewController.pauseLightBlinkTimer?.invalidate()
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = false
            playbackControllerLight_error.isHidden = true
        case .error:
            ViewController.pauseLightBlinkTimer?.invalidate()
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = false
        case .none:
            ViewController.pauseLightBlinkTimer?.invalidate()
            playbackControllerLight_play.isHidden = true
            playbackControllerLight_pause.isHidden = true
            playbackControllerLight_loading.isHidden = true
            playbackControllerLight_error.isHidden = true
        }
    }
    
    ///Player
    @objc func playerDidFinishPlaying(sender: Notification) {
        ViewController.`repeat` ? play(from: ViewController.playbackIndex) : advance()
    }
    func advance(){
        setSystemStatus(to: .busy)
        if ViewController.playbackIndex < ViewController.playableQueue.count - 1{
            play(from: ViewController.playbackIndex + 1)
        } else {
            ViewController.playableQueue.shuffle()
            tprint("Stream was mixed (1)")
            play(from: 0)
        }
    }
    func reverse(){
        setSystemStatus(to: .busy)
        if ViewController.playbackIndex > 0{
            play(from: ViewController.playbackIndex - 1)
        } else {
            ViewController.playableQueue.shuffle()
            tprint("Stream was mixed (2)")
            play(from: 0)
        }
    }
    func play(from: Int = 0, init: Bool = false){
        if `init`{
            tclear()
            tprint("", raw: true)
            tprint("", raw: true)
            tprint(" ***", raw: true)
            tprint(ViewController.description, raw: true)
            TBLabel.stringValue = ViewController.description
            tprint(" ***", raw: true)
        }else{
            tprint(AutomneAxioms.messages.randomElement() ?? "Playing...")
        }
        setPlaybackControllerState(to: .loading)
        ViewController.playbackIndex = from
        let track = ViewController.playableQueue[from]
        let url = URL(string: track.stream_url!
            + AutomneAxioms.SCTailQueue + AutomneKeys.scKey)
        ViewController.player = AVPlayer(url: url!)
        let playerItem = AVPlayerItem.init(url: url!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        ViewController.player = AVPlayer.init(playerItem: playerItem)
        ViewController.player.volume = 1.0
        ViewController.player.play()
        checkAndInvokeImage()
        if ViewController.player.error != nil{
            setSystemStatus(to: .error)
            setPlaybackControllerState(to: .error)
            tprint("ERROR7: " + ViewController.player.error!.localizedDescription)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.setSystemStatus(to: .playing)
                self.setPlaybackControllerState(to: .playing)
            }
            
        }
    }
    func pause(){
        ViewController.player.pause()
        ViewController.sleepTimer?.invalidate()
        setSystemStatus(to: .paused)
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
            setSystemStatus(to: .playing)
            setPlaybackControllerState(to: .playing)
        }
    }
    
    ///API
    func retrieveFrequencies(initial: Bool = false){
        SFX.playSFX(sfx: SFX.Effects.radioSetup)
        tprint("Connecting to First Responder...")
        setFreqLabel(to: "Retrieving...")
        TBLabel.stringValue = "Retrieving..."
        self.setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        self.setPlaybackControllerState(to: .none)
        let url = URL(
            string: AutomneAxioms.firstResponderNoseQueue +
                AutomneKeys.firstResponderKey
            )!
        AF.request(url).response { response in
            switch response.result {
            case .success( _):
                do{
                    let decoder = JSONDecoder()
                    let obj = try decoder.decode(FirstResponderAnswer.self, from: response.data!)
                    AutomneKeys.scKey = obj.scKey!
                    ViewController.retrievedFrequencies = obj.frequencies!
                    let task = {
                        self.switchFrequency(to: ViewController.retrievedFrequencies[0], index: 0)
                        self.tprint("SUCCESS")
                        self.tprint("Retrieved " + String(ViewController.retrievedFrequencies.count) + " frequencies")
                        ViewController.frequencyMessage = obj.message ?? "No message"
                        ViewController.latestVersion = obj.version ?? ""
                        if(initial){
                            self.retrieveTracks(frequency: ViewController.selectedFrequency!, initial: true)
                        }else{
                            self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
                            SFX.shutUp()
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
                catch{
                    self.tprint("ERROR4: " + error.localizedDescription)
                    self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                    SFX.shutUp()
                }
                
            case .failure(let error):
                self.tprint("ERROR3: " + error.localizedDescription)
                self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                SFX.shutUp()
            }
        }
    }
    
    func retrieveTracks(frequency: AutomneProperties.Frequency, initial: Bool = false){
        ViewController.sleepTimer?.invalidate()
        setPlaybackLabel(to: ". . . . .")
        TBLabel.stringValue = ". . . . ."
        setFreqLight(to: .tuning, new: frequency.isNew!)
        if !initial { SFX.playSFX(sfx: SFX.Effects.radioSetup) }
        setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        setPlaybackControllerState(to: .none)
        tprint("Retrieving audio data...")
        let url = URL(
            string: AutomneAxioms.SCNoseQueue
                + AutomneAxioms.SCPlaylistQueue
                + frequency.playlistID!
                + AutomneAxioms.SCTailQueue
                + AutomneKeys.scKey
            )!
        
        AF.request(url).response { response in
            switch response.result {
            case .success( _):
                do{
                    let decoder = JSONDecoder()
                    let obj = try decoder.decode(Playlist.self, from: response.data!)
                    let task = {
                        if obj.tracks != nil{
                            self.fillQueue(with: obj.tracks!)
                            ViewController.description = obj.description ?? "No description"
                            ViewController.playlistArtwork = obj.artwork_url ?? ""
                            self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
                            self.setPlaybackLabel(to: "Ready")
                            self.TBLabel.stringValue = "Automne is ready"
                            SFX.shutUp()
                            self.setFreqLight(to: .tuned, new: frequency.isNew!)
                            ViewController.setFrequencyIndex = ViewController.selectedFrequencyIndex
                            self.tprint("SUCCESS")
                            self.tprint("***", raw: true)
                            self.tprint("[First Responder message]", raw: true, noBreak: true)
                            self.tprint(ViewController.frequencyMessage, raw: true)
                            AutomneAxioms.messages.append(ViewController.frequencyMessage)
                            self.tprint("***", raw: true)
                            if ViewController.defaults.integer(forKey: "appearance") == 0{
                                ViewController.defaults.set(1, forKey: "appearance")
                                self.tprint("Power is applied for the first time, it's recommended to press 'HELP'.", raw: true)
                                self.tprint("Check 'automne.fetchdev.host' for further info", raw: true)
                                self.tprint("***", raw: true)
                                ViewController.defaults.set(2, forKey: "artwork")
                            }
                            if ViewController.latestVersion != self.appVersion{
                                self.tprint("ATTENTION: Latest version v\(ViewController.latestVersion) is available at automne.fetchdev.host/release")
                            }
                        } else {
                            self.tprint("ERROR10: No tracks/broken frequency")
                            self.setSystemStatus(to: AutomneProperties.SystemStatus.error)
                            SFX.shutUp()
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
                catch{
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
    func fillQueue(with: [Tracks]){
        ViewController.playableQueue.removeAll()
        for track in with{
            ViewController.playableQueue.append(track)
        }
        ViewController.playableQueue.shuffle()
    }
    
    ///Frequency controller
    enum FrequencyControllerState{
        case tuning
        case tuned
        case unknown
    }
    func switchFrequency(to: AutomneProperties.Frequency, index: Int){
        ViewController.selectedFrequency = to
        ViewController.selectedFrequencyIndex = index
        frequencyControllerLabel.stringValue = to.name ?? "Undefined"
        setFreqLight(to: index == ViewController.setFrequencyIndex ? .tuned : .unknown, new: to.isNew!)
    }
    func setFreqLabel(to: String){
        frequencyControllerLabel.stringValue = to
    }
    func setFreqLight(to: FrequencyControllerState, new: Bool = false){
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
    }
    
    ///Main display
    enum MainDisplayState{
        case song
        case artist
        case time
        case volume
        case frequency
    }
    
    func setPlaybackLabel(to: String){
        mainLabel.stringValue = to
    }
    
    @objc func mainDisplayTick(){
        if ViewController.systemStatus == .playing || ViewController.systemStatus == .paused{
            let fi = ViewController.states.firstIndex(of: ViewController.mainDisplayState) ?? 0
            ViewController.mainDisplayState =
                ViewController.states[fi == ViewController.states.count - 1 ? 0 : fi + 1]
            switch ViewController.mainDisplayState {
            case .song:
                setPlaybackLabel(to: ViewController.playableQueue[ViewController.playbackIndex].title ?? "Unknown title")
            case .artist:
                setPlaybackLabel(to: "By " +
                    (ViewController.playableQueue[ViewController.playbackIndex].user?.username ?? "unknown artist"))
            case .volume:
                setPlaybackLabel(to: "    Vol: " + String(ViewController.savedVolume))
            case .frequency:
                setPlaybackLabel(to: ViewController.retrievedFrequencies[ViewController.setFrequencyIndex].name ?? "Unknown station")
            default: ()
            }
        }
        if ViewController.player.reasonForWaitingToPlay != nil{
            tprint("WARN: " + ViewController.player.reasonForWaitingToPlay!.rawValue)
            tprint("TRY REBOOTING")
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
    func tprint(_ item: String, raw: Bool = false, noBreak: Bool = false, noWipe: Bool = false){
        hideImage()
        let key = raw ? 27 : 25
        if item.count > key && !noBreak{
            var s = item
            for i in 1...item.count / key {
                s.insert(contentsOf: raw ? "\n" : "\n  ", at: s.index(s.startIndex, offsetBy: i * key))
            }
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + s + "\n"
        } else {
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + item + "\n"
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
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    @objc func toggleImage(){
        if (ViewController.systemStatus == .paused || ViewController.systemStatus == .playing)
            && ViewController.defaults.integer(forKey: "artwork") != 0{
            terminalImage.isHidden = false
        }
        else{
            ViewController.terminalImageTimer = Timer.scheduledTimer(
                timeInterval: 4.5,
                target: self,
                selector: #selector(self.toggleImage), userInfo: nil, repeats: false)
        }
    }
    func hideImage(){
        ViewController.terminalImageTimer?.invalidate()
        terminalImage.isHidden = true
        ViewController.terminalImageTimer = Timer.scheduledTimer(
            timeInterval: 4.5,
            target: self,
            selector: #selector(self.toggleImage), userInfo: nil, repeats: false)
    }
    func removeImage(){
        terminalImage.isHidden = true
        ViewController.terminalImageTimer?.invalidate()
    }
    func checkAndInvokeImage(){
        switch ViewController.defaults.integer(forKey: "artwork") {
        case 1:
            if ViewController.playableQueue[ViewController.playbackIndex].artwork_url != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.invokeImage(from: URL(string: ((ViewController.playableQueue[ViewController.playbackIndex].artwork_url)?.replacingOccurrences(of: "large", with: "t500x500"))!)!)
                }
            }
        case 2:
            if ViewController.playlistArtwork != "" && !ViewController.playlistArtworkServed{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.invokeImage(from: URL(string: ViewController.playlistArtwork.replacingOccurrences(of: "large", with: "t500x500"))!)
                    ViewController.playlistArtworkServed = true
                }
            }
        default: ()
        }
    }
    func invokeImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { self.tprint("ERROR: Fail loading artwork"); return }
            DispatchQueue.main.async() { [weak self] in
                self?.terminalImage.image = NSImage(data: data)
            }
        }
    }
    func stripe() {
        if ViewController.systemStatus == .playing
            || ViewController.systemStatus == .paused
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
