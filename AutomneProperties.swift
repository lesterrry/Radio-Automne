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
        case paused
        case playing
    }
    
    public struct Frequency: Codable {
        let name: String?
        let num: Double?
        let isNew: Bool?
        let playlistID: String?
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case num = "num"
            case isNew = "is_new"
            case playlistID = "playlist_id"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            num = try values.decodeIfPresent(Double.self, forKey: .num)
            isNew = try values.decodeIfPresent(Bool.self, forKey: .isNew)
            playlistID = try values.decodeIfPresent(String.self, forKey: .playlistID)
        }
        
    }
}
