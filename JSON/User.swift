/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User : Codable {
	let permalink_url : String?
	let permalink : String?
	let username : String?
	let uri : String?
	let last_modified : String?
	let id : Int?
	let kind : String?
	let avatar_url : String?

	enum CodingKeys: String, CodingKey {

		case permalink_url = "permalink_url"
		case permalink = "permalink"
		case username = "username"
		case uri = "uri"
		case last_modified = "last_modified"
		case id = "id"
		case kind = "kind"
		case avatar_url = "avatar_url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		permalink_url = try values.decodeIfPresent(String.self, forKey: .permalink_url)
		permalink = try values.decodeIfPresent(String.self, forKey: .permalink)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		uri = try values.decodeIfPresent(String.self, forKey: .uri)
		last_modified = try values.decodeIfPresent(String.self, forKey: .last_modified)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
	}

}