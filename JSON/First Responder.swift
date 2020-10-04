//
//  First Responder.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import Foundation

struct FirstResponderAnswer: Codable {
    let scKey: String?
    let frequencies: [AutomneProperties.Frequency]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case scKey = "sc_key"
        case frequencies = "frequencies"
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        scKey = try values.decodeIfPresent(String.self, forKey: .scKey)
        frequencies = try values.decodeIfPresent([AutomneProperties.Frequency].self, forKey: .frequencies)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
