//
//  First Responder.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation

struct FirstResponderAnswer: Codable {
    let scKey: String?
    let frequencies: [Frequency]?
    let version: String?
    let narratives: [String]?
    
    enum CodingKeys: String, CodingKey {
        case scKey = "sc_key"
        case frequencies = "frequencies"
        case version = "version"
        case narratives = "narratives"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scKey = try values.decodeIfPresent(String.self, forKey: .scKey)
        frequencies = try values.decodeIfPresent([Frequency].self, forKey: .frequencies)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        narratives = try values.decodeIfPresent([String].self, forKey: .narratives)
    }
}

public struct Frequency: Codable {
    let name: String?
    let num: String?
    let isNew: Bool?
    let isStream: Bool?
    let playlistID: String?
    let streamURL: String?
    let streamDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case num = "num"
        case isNew = "is_new"
        case isStream = "is_stream"
        case playlistID = "playlist_id"
        case streamURL = "stream_url"
        case streamDescription = "stream_description"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        num = try values.decodeIfPresent(String.self, forKey: .num)
        isNew = try values.decodeIfPresent(Bool.self, forKey: .isNew)
        isStream = try values.decodeIfPresent(Bool.self, forKey: .isStream)
        playlistID = try values.decodeIfPresent(String.self, forKey: .playlistID)
        streamURL = try values.decodeIfPresent(String.self, forKey: .streamURL)
        streamDescription = try values.decodeIfPresent(String.self, forKey: .streamDescription)
    }
}
