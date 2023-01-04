//
//  DetailSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation

protocol DetailSectionModel {}

enum DetailCampsiteSectionModel: DetailSectionModel {
  case headerSection(items: [DetailCampsiteHeaderItem])
  case locationSection(header: String, items: [DetailLocationItem])
  case facilitySection(header: String, items:[DetailCampsiteFacilityItem])
  case infoSection(items: [DetailCampsiteInfoItem])
  case socialSection(items: [DetailSocialItem])
  case aroundSection(items: [DetailAroundItem])
  case imageSection(header: String, items: [DetailImageItem])
}

protocol DetailItem {}

struct DetailCampsiteHeaderItem: DetailItem {
  var imageDataList: [String]
  var name: String
  var address: String
  var lctCl: String
  var facltDivNm: String
  var induty: String
  var operPDCl: String
  var operDeCl: String
  var homepage:String
  var resveCl: String
  var posblFcltyCl: String
  var tel: String
}

struct DetailLocationItem: DetailItem {
  var mapX: String
  var mapY: String
  var address: String
  var direction: String
  var weatherInfos: [WeatherInfo]
}

struct DetailCampsiteFacilityItem: DetailItem {
  // 배열화 필요
  var sbrsCl: String
}

struct DetailCampsiteInfoItem: DetailItem {
  var gnrlSiteCo: String
  var autoSiteCo: String
  var glampSiteCo: String
  var caravSiteCo: String
  
  // , -> 다른 구분점
  var sbrsEtc: String
  
  var animalCmgCl: String
  
  // , -> 다른 구분점
  var glampInnerFclty: String
  var caravInnerFclty: String
  
  var brazierCl: String
  
  var extshrCo: String
  var frprvtWrppCo: String
  var frprvtSandCo: String
  var fireSensorCo: String
  
  var overview: String
  // , -> 다른 구분점
  var themaEnvrnCl: String
  var tooltip: String
}

struct DetailSocialItem: DetailItem {
  var socialMediaInfo: SocialMediaInfo
}

struct DetailAroundItem: DetailItem {
  var mapX: String
  var mapY: String
  var radius: String
}

struct DetailImageItem: DetailItem {
  var imageUrl: String
}


