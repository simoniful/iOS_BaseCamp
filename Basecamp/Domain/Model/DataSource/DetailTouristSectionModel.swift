//
//  DetailTouristSectionModel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import Foundation

enum DetailTouristInfoSectionModel: DetailSectionModel {
  case headerSection(items: [DetailCampsiteHeaderItem])
  case locationSection(header: String, items: [DetailLocationItem])
  case facilitySection(header: String, items:[DetailCampsiteFacilityItem])
  case infoSection(header: String, items: [DetailCampsiteInfoItem])
  case aroundSection(items: [DetailAroundItem])
  case imageSection(header: String, items: [DetailImageItem])
}
