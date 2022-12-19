//
//  TouristInfoRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation

protocol TouristInfoRepositoryInterface: AnyObject {
  func requestTouristInfo() async -> Result<Campsite, Error>
}
