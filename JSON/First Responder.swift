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

struct CustomFrequencies: Codable {
    var frequencies: [Frequency]?
    enum CodingKeys: String, CodingKey {
        case frequencies
    }
    
    init(frequencies: [Frequency]?) {
        self.frequencies = frequencies
    }
    
    func reliable() -> CustomFrequencies? {
        guard let a = self.frequencies else {
            return nil
        }
        var r = CustomFrequencies(frequencies: [])
        for i in a {
            if i.reliable ?? false {
                r.frequencies?.append(i)
            }
        }
        return r
    }
}

public struct Frequency: Codable {
    let name: String
    let reliable: Bool?
    let num: String?
    let isNew: Bool?
    let isStream: Bool?
    let playlistID: String?
    let streamURL: String?
    let streamDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case name, num, reliable
        case isNew = "is_new"
        case isStream = "is_stream"
        case playlistID = "playlist_id"
        case streamURL = "stream_url"
        case streamDescription = "stream_description"
    }
    
    public init(name: String, reliable: Bool?, num: String?, isNew: Bool?, isStream: Bool?, playlistID: String?, streamURL: String?, streamDescription: String?) {
        self.name = name
        self.reliable = reliable
        self.num = num
        self.isNew = isNew
        self.isStream = isStream
        self.playlistID = playlistID
        self.streamURL = streamURL
        self.streamDescription = streamDescription
    }
}
