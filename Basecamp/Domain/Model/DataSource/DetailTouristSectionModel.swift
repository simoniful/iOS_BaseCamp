//
//  DetailTouristSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation
import RxDataSources

enum DetailTouristInfoSectionModel: DetailSectionModel {
  case headerSection(items: [DetailTouristInfoHeaderItem])
  case locationSection(header: String, items: [DetailLocationItem])
  case introSection(header: String, items: [any DetailTouristInfoIntroItem])
  case socialSection(header: String, items: [DetailSocialItem])
  case aroundSection(header: String, items: [DetailAroundItem])
  case imageSection(header: String, items: [DetailImageItem])
}

struct DetailTouristInfoHeaderItem: DetailItem {
  var imageDataList: [String]
  var title: String
  var address: String
  var tel: String
  var homepage: String
  var contentId: Int
  var contentTypeId: TouristInfoContentType
  var eventStartDate: Date?
  var eventEndDate: Date?
  var overview: String
}

protocol DetailTouristInfoIntroItem: DetailItem {
  associatedtype IntroType: TouristInfoIntro
  var intro: IntroType { get }
}

struct DetailTouristInfoSpotIntroItem: DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroSpot
}

struct DetailTouristInfoCultureIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroCulture
}

struct DetailTouristInfoFestivalIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroFestival
}

struct DetailTouristInfoLeisureIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroLeisure
}

struct DetailTouristInfoAccommodationIntroItem: DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroAccommodation
}

struct DetailTouristInfoShoppingIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroShopping
}

struct DetailTouristInfoRestaurantIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroRestaurant
}

struct DetailTouristInfoTourCourseIntroItem:  DetailTouristInfoIntroItem {
  var intro: TouristInfoIntroTourCourse
}

extension DetailTouristInfoSectionModel: SectionModelType {
  typealias Item = DetailItem
  
  init(original: DetailTouristInfoSectionModel, items: [Item]) {
    self = original
  }
  
  var headers: String? {
    switch self {
    case .locationSection(let header, _),
        .introSection(let header, _),
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
    case .introSection(_, let items):
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



