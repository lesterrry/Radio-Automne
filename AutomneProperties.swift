//
//  AutomneProperties.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation
public class AutomneProperties{
    enum SystemStatus: String {
        case busy
        case ready
        case error
        case standby
        case active
        case unset
    }
    enum PlaybackControllerState{
        case playing
        case paused
        case loading
        case error
        case none
    }
}
