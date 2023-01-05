//
//  DetailSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import Foundation
import RxDataSources

protocol DetailSectionModel {}

enum DetailCampsiteSectionModel: DetailSectionModel {
  case headerSection(items: [DetailCampsiteHeaderItem])
  case locationSection(header: String, items: [DetailLocationItem])
  case facilitySection(header: String, items:[DetailCampsiteFacilityItem])
  case infoSection(items: [DetailCampsiteInfoItem])
  case socialSection(header: String, items: [DetailSocialItem])
  case aroundSection(header: String, items: [DetailAroundItem])
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
  var facility: Facility
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

extension DetailCampsiteSectionModel: SectionModelType {
  typealias Item = DetailItem
  
  init(original: DetailCampsiteSectionModel, items: [Item]) {
    self = original
  }
  
  var headers: String? {
    switch self {
    case .locationSection(let header, _),
         .facilitySection(let header, _),
         .socialSection(let header, _),
         .aroundSection(let header, _),
         .imageSection(let header, _):
      return header
    default:
      return nil
    }
  }
  
  var items: [Item] {
    switch self {
    case .headerSection(let items):
      return items
    case .locationSection(_, let items):
      return items
    case .facilitySection(_, let items):
      return items
    case .infoSection(let items):
      return items
    case .socialSection(_, let items):
      return items
    case .aroundSection(_, let items):
      return items
    case .imageSection(_, let items):
      return items
    }
  }
}


