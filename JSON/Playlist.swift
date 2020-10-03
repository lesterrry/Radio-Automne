/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Playlist : Codable {
	let duration : Int?
	let release_day : String?
	let permalink_url : String?
	let genre : String?
	let permalink : String?
	let purchase_url : String?
	let release_month : String?
	let description : String?
	let tags : String?
	let uri : String?
	let label_name : String?
	let label : String?
	let tag_list : String?
	let release_year : String?
	let track_count : Int?
	let user_id : Int?
	let last_modified : String?
	let license : String?
	let tracks : [Tracks]?
	let playlist_type : String?
	let id : Int?
	let tracks_uri : String?
	let downloadable : String?
	let sharing : String?
	let created_at : String?
	let release : String?
	let likes_count : Int?
	let kind : String?
	let title : String?
	let type : String?
	let purchase_title : String?
	let artwork_url : String?
	let ean : String?
	let streamable : Bool?
	let user : User?
	let embeddable_by : String?
	let label_id : String?

	enum CodingKeys: String, CodingKey {

		case duration = "duration"
		case release_day = "release_day"
		case permalink_url = "permalink_url"
		case genre = "genre"
		case permalink = "permalink"
		case purchase_url = "purchase_url"
		case release_month = "release_month"
		case description = "description"
		case tags = "tags"
		case uri = "uri"
		case label_name = "label_name"
		case label = "label"
		case tag_list = "tag_list"
		case release_year = "release_year"
		case track_count = "track_count"
		case user_id = "user_id"
		case last_modified = "last_modified"
		case license = "license"
		case tracks = "tracks"
		case playlist_type = "playlist_type"
		case id = "id"
		case tracks_uri = "tracks_uri"
		case downloadable = "downloadable"
		case sharing = "sharing"
		case created_at = "created_at"
		case release = "release"
		case likes_count = "likes_count"
		case kind = "kind"
		case title = "title"
		case type = "type"
		case purchase_title = "purchase_title"
		case artwork_url = "artwork_url"
		case ean = "ean"
		case streamable = "streamable"
		case user = "user"
		case embeddable_by = "embeddable_by"
		case label_id = "label_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		duration = try values.decodeIfPresent(Int.self, forKey: .duration)
		release_day = try values.decodeIfPresent(String.self, forKey: .release_day)
		permalink_url = try values.decodeIfPresent(String.self, forKey: .permalink_url)
		genre = try values.decodeIfPresent(String.self, forKey: .genre)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		purchase_url = try values.decodeIfPresent(String.self, forKey: .purchase_url)
		release_month = try values.decodeIfPresent(String.self, forKey: .release_month)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		tags = try values.decodeIfPresent(String.self, forKey: .tags)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
		label_name = try values.decodeIfPresent(String.self, forKey: .label_name)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		tag_list = try values.decodeIfPresent(String.self, forKey: .tag_list)
		release_year = try values.decodeIfPresent(String.self, forKey: .release_year)
		track_count = try values.decodeIfPresent(Int.self, forKey: .track_count)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		last_modified = try values.decodeIfPresent(String.self, forKey: .last_modified)
		license = try values.decodeIfPresent(String.self, forKey: .license)
		tracks = try values.decodeIfPresent([Tracks].self, forKey: .tracks)
		playlist_type = try values.decodeIfPresent(String.self, forKey: .playlist_type)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		tracks_uri = try values.decodeIfPresent(String.self, forKey: .tracks_uri)
		downloadable = try values.decodeIfPresent(String.self, forKey: .downloadable)
		sharing = try values.decodeIfPresent(String.self, forKey: .sharing)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		release = try values.decodeIfPresent(String.self, forKey: .release)
		likes_count = try values.decodeIfPresent(Int.self, forKey: .likes_count)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		purchase_title = try values.decodeIfPresent(String.self, forKey: .purchase_title)
		artwork_url = try values.decodeIfPresent(String.self, forKey: .artwork_url)
		ean = try values.decodeIfPresent(String.self, forKey: .ean)
		streamable = try values.decodeIfPresent(Bool.self, forKey: .streamable)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		embeddable_by = try values.decodeIfPresent(String.self, forKey: .embeddable_by)
		label_id = try values.decodeIfPresent(String.self, forKey: .label_id)
	}

}
