//
//  AppDelegate.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var nightModeMenuItem: NSMenuItem!
    
    var window = NSWindow(contentRect: NSScreen.main!.frame, styleMask: [], backing: .buffered, defer: false)
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
//    MARK: To do in the future but it sucks now because of all the instances and stuff
//    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
//        let myMenu = NSMenu(title: "MyMenu")
//        let myMenuItem = NSMenuItem(title: "Toggle", action: #selector(self.playPause), keyEquivalent: "")
//        myMenu.addItem(myMenuItem)
//        return myMenu
//    }
//
//    @objc func playPause(){
//        if ViewController.playbackControllerState == .paused {
//            ViewController.resume()
//        } else if ViewController.playbackControllerState == .playing {
//            ViewController.pause()
//        }
//    }

    @IBAction func nightModePressed(_ sender: Any) {
        switch nightModeMenuItem.state{
            case .off:
                nightModeMenuItem.state = .on
                window.backgroundColor = .black
                window.titlebarAppearsTransparent = true
                window.center()
                window.toggleFullScreen(nil)
                let controller = NSWindowController(window: window)
                controller.showWindow(self)
                window.orderBack(nil)
            case .on:
                nightModeMenuItem.state = .off
                window.close()
            default:
                nightModeMenuItem.state = .off
                window.close()
        }
    }
}

