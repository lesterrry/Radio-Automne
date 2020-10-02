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

class ViewController: NSViewController {
    
    //*********************************************************************
    //SYSTEM
    //*********************************************************************
    static var systemStatus = AutomneProperties.SystemStatus.standby
    
    //*********************************************************************
    //OUTLETS
    //*********************************************************************
    @IBOutlet weak var terminalImage: NSImageView!
    @IBOutlet weak var standbyButton: NSButton!
    @IBOutlet weak var mainLabel: NSTextField!
    @IBOutlet weak var repeatStatusLight: NSImageView!
    @IBOutlet weak var frequencyControllerLabel: NSTextField!
    @IBOutlet weak var volumeKnob: NSImageView!
    @IBOutlet weak var statusLight: NSImageView!
    @IBAction func pauseClicked(_ sender: Any) {
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        if ViewController.systemStatus == .playing {
            pause()
        }
    }
    @IBOutlet weak var terminal: NSTextField!
    @IBOutlet weak var frequencyControllerLight_tune: NSImageView!
    @IBOutlet weak var frequencyControllerLight_new: NSImageView!
    @IBOutlet weak var glitchStripe: NSImageView!
    @IBOutlet weak var playbackControllerLight_play: NSImageView!
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
            play()
        }
        else if ViewController.systemStatus == .paused {
            resume()
        }
    }
    @IBAction func setupClicked(_ sender: Any) {
        //TODO
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        tprint("Nothing to setup yet")
    }
    @IBAction func helpClicked(_ sender: Any) {
        //TODO
        if ViewController.systemStatus != .busy{
            SFX.playSFX(sfx: SFX.Effects.buttonClick)
        }
        tprint("Nothing to help with yet")
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
    static var playableQueue: [Tracks] = []
    static var playbackIndex = 0
    static var selectedFrequency: AutomneProperties.Frequency? = nil
    static var selectedFrequencyIndex = -1
    static var setFrequencyIndex = -1
    static var retrievedFrequencies: [AutomneProperties.Frequency] = []
    static var `repeat` = false;
    static var ticker: Timer!
    static var pauseLightBlinkTimer: Timer!
    static var mainDisplaySwitchTimer: Timer!
    static var longTicker: Timer!
    static var terminalImageTimer: Timer!
    static var volumeKnobAngle: CGFloat = 0.0
    static var savedVolume = -1
    static var firstCall = true
    static var mainDisplayState = MainDisplayState.song
    static let states = [MainDisplayState.volume, MainDisplayState.frequency, MainDisplayState.song, MainDisplayState.artist, MainDisplayState.time]
    static var description: String = ""
    let fetchLogo = "### ### ### ### # #\n#   #    #  #   # #\n##  ###  #  #   ###\n#   #    #  #   # #\n#   ###  #  ### # #"
    
    //*********************************************************************
    //FUNCTIONS
    //*********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        allLights = [frequencyControllerLight_new,
                     frequencyControllerLight_tune,
                     repeatStatusLight,
                     playbackControllerLight_play,
                     playbackControllerLight_pause,
                     playbackControllerLight_error,
                     playbackControllerLight_loading]
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
    func powerOn(){
        standbyButton.image = NSImage(named: "OnStandby_on")
        setSystemStatus(to: AutomneProperties.SystemStatus.busy)
        SFX.playSFX(sfx: SFX.Effects.powerOn)
        for light in allLights {
            light.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            for light in self.allLights {
                light.isHidden = true
            }
            self.setPlaybackLabel(to: "Radio Automne")
            self.tprint("Loading mainframe...")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.setFreqLabel(to: "Booting...")
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
            self.tprint(self.fetchLogo, raw: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            self.retrieveFrequencies(initial: true)
        }
    }
    
    func powerOff(){
        removeImage()
        standbyButton.image = NSImage(named: "OnStandby_off")
        setSystemStatus(to: .standby)
        setFreqLabel(to: "")
        setPlaybackLabel(to: "")
        ViewController.player.pause()
        for light in allLights{
            light.isHidden = true
        }
        ViewController.pauseLightBlinkTimer?.invalidate()
        terminal.stringValue = ""
        
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
            self.mainLabel.stringValue = "   -" + String(val / 60) + ":" + String(val % 60)
        }
    }
    func setSystemStatus(to: AutomneProperties.SystemStatus){
        ViewController.systemStatus = to
        
        switch to {
        case .playing, .ready, .paused:
            statusLight.image = NSImage.init(named: "StatusLight_ready")
        default:
            statusLight.image = NSImage.init(named: "StatusLight_" + to.rawValue)
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
        playbackControllerLight_play.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.playbackControllerLight_play.isHidden = true
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
            tprint("Stream was reordered (1)")
            play(from: 0)
        }
    }
    func reverse(){
        setSystemStatus(to: .busy)
        if ViewController.playbackIndex > 0{
            play(from: ViewController.playbackIndex - 1)
        } else {
            ViewController.playableQueue.shuffle()
            tprint("Stream was reordered (2)")
            play(from: 0)
        }
        
    }
    func play(from: Int = 0){
        tclear()
        tprint("", raw: true)
        tprint("", raw: true)
        tprint(" ***", raw: true)
        tprint(ViewController.description)
        tprint(" ***", raw: true)
        setPlaybackControllerState(to: .loading)
        //let url = URL.init(string: "https://api.fetchdev.host/m.mp3")
        //let url = URL(string: "https://fetchdev.host/s.mp3")
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
            if ViewController.playableQueue[ViewController.playbackIndex].artwork_url != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.invokeImage(from: URL(string: ViewController.playableQueue[ViewController.playbackIndex].artwork_url!)!)
                }
            }
        }
    }
    func pause(){
        ViewController.player.pause()
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.switchFrequency(to: ViewController.retrievedFrequencies[0], index: 0)
                        self.tprint("SUCCESS")
                        self.tprint("Retrieved " + String(ViewController.retrievedFrequencies.count) + " frequencies")
                        if(initial){
                            self.retrieveTracks(frequency: ViewController.selectedFrequency!, initial: true)
                        }else{
                            self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
                            SFX.shutUp()
                        }
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
        setPlaybackLabel(to: "Wait...")
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.fillQueue(with: obj.tracks!)
                        ViewController.description = obj.description ?? "No description"
                        self.setSystemStatus(to: AutomneProperties.SystemStatus.ready)
                        self.setPlaybackLabel(to: "Ready")
                        SFX.shutUp()
                        self.setFreqLight(to: .tuned, new: frequency.isNew!)
                        ViewController.setFrequencyIndex = ViewController.selectedFrequencyIndex
                        self.tprint("SUCCESS")
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
                mainLabel.stringValue = ViewController.playableQueue[ViewController.playbackIndex].title ?? "Unknown title"
            case .artist:
                mainLabel.stringValue = "By " +
                    (ViewController.playableQueue[ViewController.playbackIndex].user?.username ?? "unknown artist")
            case .volume:
                mainLabel.stringValue = "    Vol: " + String(ViewController.savedVolume)
            case .frequency:
                mainLabel.stringValue = ViewController.retrievedFrequencies[ViewController.setFrequencyIndex].name ?? "Unknown station"
            default: ()
            }
        }
    }
    
    ///Terminal
    func tclear(){
        hideImage()
        terminal.stringValue = ""
    }
    func tprint(_ item: String, raw: Bool = false){
        hideImage()
        let o = terminal.stringValue.components(separatedBy: .newlines)
        if o.count > 10{
            var n = ""
            for s in 5...o.count - 2{
                n.append(o[s] + "\n" )
            }
            n.append(o[o.count - 1])
            terminal.stringValue = n
        }
        if item.count > 24 && !raw{
            var s = item
            s.insert(contentsOf: raw ? "-\n" : "-\n  ", at: s.index(s.startIndex, offsetBy: 24))
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + s + "\n"
        } else {
            terminal.stringValue = terminal.stringValue + (raw ? "" : "> ") + item + "\n"
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    @objc func toggleImage(){
        if ViewController.systemStatus == .paused || ViewController.systemStatus == .playing {
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
    func invokeImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { self.tprint("ERROR: Fail loading artwork"); return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
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
