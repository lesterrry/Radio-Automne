//
//  CoreSound.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 02.10.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation
import AudioToolbox
import Cocoa

class AutomneCore {
    private static let volurl = Bundle.main.url(forResource: "GetVolume", withExtension: "scpt")
    private static var volerror: NSDictionary?
    private static let volscriptObject = NSAppleScript(contentsOf: volurl!, error: &volerror)
    
    private static let slurl = Bundle.main.url(forResource: "SystemSleep", withExtension: "scpt")
    private static var slerror: NSDictionary?
    private static let slscriptObject = NSAppleScript(contentsOf: slurl!, error: &slerror)
    
    private static let churl = Bundle.main.url(forResource: "SystemSleepCheck", withExtension: "scpt")
    private static var cherror: NSDictionary?
    private static let chscriptObject = NSAppleScript(contentsOf: churl!, error: &cherror)
    
    public static func getSystemVolume() -> Int{
        if let outputString = volscriptObject?.executeAndReturnError(&volerror).stringValue {
            return Int(outputString) ?? -1
        } else if (volerror != nil) {
            print("ERROR8: ", volerror!)
            return -1
        }
        
        return -1
    }
    public static func systemSleep(){
        if (slscriptObject?.executeAndReturnError(&slerror).stringValue) != nil {
            
        } else if (slerror != nil) {
            print("ERROR9: " + slerror!.description)
        }
    }
    public static func systemSleepCheck(){
        if (chscriptObject?.executeAndReturnError(&cherror).stringValue) != nil {
            
        } else if (cherror != nil) {
            print("ERROR9: " + cherror!.description)
        }
    }
    public static func notify(title: String, subtitle: String = ""){
        if !NSApplication.shared.isActive{
            let notification = NSUserNotification()
            notification.hasActionButton = false
            notification.setValue(true, forKey: "_ignoresDoNotDisturb")
            notification.title = title
            notification.informativeText = subtitle
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
}
