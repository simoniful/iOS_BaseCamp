//
//  DetailSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation

enum DetailSectionModel {
  case headerSection(items: [DetailHeaderItem])
  case locationSection(header: String, items: [DetailLocationItem])
  case facilitySection(header: String, items:[Campsite])
  case infoSection(header: String, items: [TouristInfo])
}

protocol DetailItem {}

struct DetailHeaderItem: DetailItem {
  var imageDataList: [String]
  var name: String
  var address: String
  var lctCl: String
  var facltDivNm: String
  var induty: String
  var operPdCl: String
  var operDeCl: String
  var homepage:String
  var resveCl: String
  var posblFcltyCl: String
  var tel: String
}

struct DetailLocationItem: DetailItem {
  let mapX: String
  let mapY: String
  var address: String
  var direction: String
}

struct DetailFacilityItem: DetailItem {
  
}

struct DetailInfoItem: DetailItem {
  
}
