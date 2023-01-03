//
//  SocialMediaInfo.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

protocol SocialMediaInfo: Codable {
  var type: String { get }
  var title: String { get }
  var link: String { get }
  var description: String { get }
}
