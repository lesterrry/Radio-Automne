/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Tracks : Codable {
	let kind : String?
	let id : Int?
	let created_at : String?
	let user_id : Int?
	let duration : Int?
	let commentable : Bool?
	let comment_count : Int?
	let state : String?
	let original_content_size : Int?
	let last_modified : String?
	let sharing : String?
	let tag_list : String?
	let permalink : String?
	let streamable : Bool?
	let embeddable_by : String?
	let purchase_url : String?
	let purchase_title : String?
	let label_id : Int?
	let genre : String?
	let title : String?
	let description : String?
	let label_name : String?
	let release : String?
	let track_type : String?
	let key_signature : String?
	let isrc : String?
	let video_url : String?
	let bpm : Int?
	let release_year : Int?
	let release_month : Int?
	let release_day : Int?
	let original_format : String?
	let license : String?
	let uri : String?
	let user : User?
	let user_uri : String?
	let permalink_url : String?
	let artwork_url : String?
	let stream_url : String?
	let download_url : String?
	let waveform_url : String?
	let domain_lockings : String?
	let available_country_codes : String?
	//let label : String?
	let secret_token : String?
	let secret_uri : String?
	let user_favorite : String?
	let user_playback_count : String?
	let playback_count : Int?
	let download_count : Int?
	let favoritings_count : Int?
	let reposts_count : Int?
	let downloadable : Bool?
	let downloads_remaining : Int?

	enum CodingKeys: String, CodingKey {

		case kind = "kind"
		case id = "id"
		case created_at = "created_at"
		case user_id = "user_id"
		case duration = "duration"
		case commentable = "commentable"
		case comment_count = "comment_count"
		case state = "state"
		case original_content_size = "original_content_size"
		case last_modified = "last_modified"
		case sharing = "sharing"
		case tag_list = "tag_list"
		case permalink = "permalink"
		case streamable = "streamable"
		case embeddable_by = "embeddable_by"
		case purchase_url = "purchase_url"
		case purchase_title = "purchase_title"
		case label_id = "label_id"
		case genre = "genre"
		case title = "title"
		case description = "description"
		case label_name = "label_name"
		case release = "release"
		case track_type = "track_type"
		case key_signature = "key_signature"
		case isrc = "isrc"
		case video_url = "video_url"
		case bpm = "bpm"
		case release_year = "release_year"
		case release_month = "release_month"
		case release_day = "release_day"
		case original_format = "original_format"
		case license = "license"
		case uri = "uri"
		case user = "user"
		case user_uri = "user_uri"
		case permalink_url = "permalink_url"
		case artwork_url = "artwork_url"
		case stream_url = "stream_url"
		case download_url = "download_url"
		case waveform_url = "waveform_url"
		case domain_lockings = "domain_lockings"
		case available_country_codes = "available_country_codes"
		//case label = "label"
		case secret_token = "secret_token"
		case secret_uri = "secret_uri"
		case user_favorite = "user_favorite"
		case user_playback_count = "user_playback_count"
		case playback_count = "playback_count"
		case download_count = "download_count"
		case favoritings_count = "favoritings_count"
		case reposts_count = "reposts_count"
		case downloadable = "downloadable"
		case downloads_remaining = "downloads_remaining"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		duration = try values.decodeIfPresent(Int.self, forKey: .duration)
		commentable = try values.decodeIfPresent(Bool.self, forKey: .commentable)
		comment_count = try values.decodeIfPresent(Int.self, forKey: .comment_count)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		original_content_size = try values.decodeIfPresent(Int.self, forKey: .original_content_size)
		last_modified = try values.decodeIfPresent(String.self, forKey: .last_modified)
		sharing = try values.decodeIfPresent(String.self, forKey: .sharing)
		tag_list = try values.decodeIfPresent(String.self, forKey: .tag_list)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		streamable = try values.decodeIfPresent(Bool.self, forKey: .streamable)
		embeddable_by = try values.decodeIfPresent(String.self, forKey: .embeddable_by)
		purchase_url = try values.decodeIfPresent(String.self, forKey: .purchase_url)
		purchase_title = try values.decodeIfPresent(String.self, forKey: .purchase_title)
		label_id = try values.decodeIfPresent(Int.self, forKey: .label_id)
		genre = try values.decodeIfPresent(String.self, forKey: .genre)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		label_name = try values.decodeIfPresent(String.self, forKey: .label_name)
		release = try values.decodeIfPresent(String.self, forKey: .release)
		track_type = try values.decodeIfPresent(String.self, forKey: .track_type)
		key_signature = try values.decodeIfPresent(String.self, forKey: .key_signature)
		isrc = try values.decodeIfPresent(String.self, forKey: .isrc)
		video_url = try values.decodeIfPresent(String.self, forKey: .video_url)
		bpm = try values.decodeIfPresent(Int.self, forKey: .bpm)
		release_year = try values.decodeIfPresent(Int.self, forKey: .release_year)
		release_month = try values.decodeIfPresent(Int.self, forKey: .release_month)
		release_day = try values.decodeIfPresent(Int.self, forKey: .release_day)
		original_format = try values.decodeIfPresent(String.self, forKey: .original_format)
		license = try values.decodeIfPresent(String.self, forKey: .license)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		user_uri = try values.decodeIfPresent(String.self, forKey: .user_uri)
		permalink_url = try values.decodeIfPresent(String.self, forKey: .permalink_url)
		artwork_url = try values.decodeIfPresent(String.self, forKey: .artwork_url)
		stream_url = try values.decodeIfPresent(String.self, forKey: .stream_url)
		download_url = try values.decodeIfPresent(String.self, forKey: .download_url)
		waveform_url = try values.decodeIfPresent(String.self, forKey: .waveform_url)
		domain_lockings = try values.decodeIfPresent(String.self, forKey: .domain_lockings)
		available_country_codes = try values.decodeIfPresent(String.self, forKey: .available_country_codes)
		//label = try values.decodeIfPresent(String.self, forKey: .label)
		secret_token = try values.decodeIfPresent(String.self, forKey: .secret_token)
		secret_uri = try values.decodeIfPresent(String.self, forKey: .secret_uri)
		user_favorite = try values.decodeIfPresent(String.self, forKey: .user_favorite)
		user_playback_count = try values.decodeIfPresent(String.self, forKey: .user_playback_count)
		playback_count = try values.decodeIfPresent(Int.self, forKey: .playback_count)
		download_count = try values.decodeIfPresent(Int.self, forKey: .download_count)
		favoritings_count = try values.decodeIfPresent(Int.self, forKey: .favoritings_count)
		reposts_count = try values.decodeIfPresent(Int.self, forKey: .reposts_count)
		downloadable = try values.decodeIfPresent(Bool.self, forKey: .downloadable)
		downloads_remaining = try values.decodeIfPresent(Int.self, forKey: .downloads_remaining)
	}

}
