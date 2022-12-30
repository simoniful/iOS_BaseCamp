//
//  TouristInfoRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

protocol TouristInfoRequestDTO: Codable {
  var moblieOS: String { get }
  var mobileApp: String { get }
  var serviceKey: String { get }
  
  var toDictionary: [String: Any] { get }
}
