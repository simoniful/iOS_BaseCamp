//
//  CampsiteRequestDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

protocol CampsiteRequestDTO: Codable {
  var numOfRows: Int { get set }
  var pageNo: Int { get set }
  var moblieOS: String { get }
  var mobileApp: String { get }
  var serviceKey: String { get }
  
  var toDictionary: [String: Any] { get }
}
