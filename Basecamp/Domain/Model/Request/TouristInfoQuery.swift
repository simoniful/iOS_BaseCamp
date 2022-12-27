//
//  TouristInfoQuery.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/20.
//

import Foundation

enum TouristInfoQueryType {
  case categoryCode(numOfRows: Int, pageNo: Int, contentTypeId: Int, cat1: String, cat2: String, cat3: String)
  case region(numOfRows: Int, pageNo: Int, contentTypeId: Int, areaCode: Int, sigunguCode: Int, cat1: String, cat2: String, cat3: String, modifiedtime: String)
  case location(numOfRows: Int, pageNo: Int, coordinate: Coordinate, radius: Int)
  case keyword(numOfRows: Int, pageNo: Int, contentTypeId: Int, keyword: String)
  case festival(numOfRows: Int, pageNo: Int, areaCode: Int, sigunguCode: Int, eventStartDate: String, eventEndDate: String)
  case stay(numOfRows: Int, pageNo: Int, areaCode: Int, sigunguCode: Int)
}
