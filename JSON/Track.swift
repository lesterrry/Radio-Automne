/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct TrackStreamURLCallback : Codable {
    let url : String?
}

struct Transcodings : Codable {
    let url : String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct Media : Codable {
    let transcodings : [Transcodings]?

    enum CodingKeys: String, CodingKey {

        case transcodings = "transcodings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transcodings = try values.decodeIfPresent([Transcodings].self, forKey: .transcodings)
    }

}

struct Track : Codable, Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        return rhs.id == lhs.id
    }
    
    var deepWave : Bool?
	let kind : String?
	let id : Int?
	let user_id : Int?
	let duration : Int?
	let permalink : String?
	let label_id : Int?
	let genre : String?
	let title : String?
	let description : String?
	let original_format : String?
	let uri : String?
	let user : User?
	let user_uri : String?
	let permalink_url : String?
	let artwork_url : String?
	let stream_url : String?
	let download_url : String?
	let waveform_url : String?
    let media: Media?

	enum CodingKeys: String, CodingKey {
		case kind = "kind"
		case id = "id"
		case user_id = "user_id"
		case duration = "duration"
		case permalink = "permalink"
		case label_id = "label_id"
		case genre = "genre"
		case title = "title"
		case description = "description"
		case original_format = "original_format"
		case uri = "uri"
		case user = "user"
		case user_uri = "user_uri"
		case permalink_url = "permalink_url"
		case artwork_url = "artwork_url"
		case stream_url = "stream_url"
		case download_url = "download_url"
		case waveform_url = "waveform_url"
        case media = "media"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		duration = try values.decodeIfPresent(Int.self, forKey: .duration)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		label_id = try values.decodeIfPresent(Int.self, forKey: .label_id)
		genre = try values.decodeIfPresent(String.self, forKey: .genre)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		original_format = try values.decodeIfPresent(String.self, forKey: .original_format)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		user_uri = try values.decodeIfPresent(String.self, forKey: .user_uri)
		permalink_url = try values.decodeIfPresent(String.self, forKey: .permalink_url)
		artwork_url = try values.decodeIfPresent(String.self, forKey: .artwork_url)
		stream_url = try values.decodeIfPresent(String.self, forKey: .stream_url)
		download_url = try values.decodeIfPresent(String.self, forKey: .download_url)
		waveform_url = try values.decodeIfPresent(String.self, forKey: .waveform_url)
        media = try values.decodeIfPresent(Media.self, forKey: .media)
        deepWave = false
	}

}
