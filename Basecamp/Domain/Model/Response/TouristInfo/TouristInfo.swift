//
//  TouristInfo.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation

struct TouristInfoData: Codable {
  let item: [TouristInfo]
  let totalCount: Int
  let pageNo: Int
  let numOfRows: Int
}

struct TouristInfo: HomeItem, Codable {
  let address, areaCode: String?
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let dist: String?
  let mainImage, subImage: String?
  let mapX, mapY, mlevel: String?
  let readcount: Int?
  let sigunguCode, tel, title: String?
  let eventStartDate, eventEndDate: Date?
}
