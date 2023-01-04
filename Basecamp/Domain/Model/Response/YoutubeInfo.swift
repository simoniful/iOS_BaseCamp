//
//  YoutubeInfo.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

struct YoutubeInfo: Codable, SocialMediaInfo {
  var type: String
  var title: String
  var link: String
  var description: String
}
