//
//  SectionLayoutManagerFactory.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/22.
//

import Foundation

protocol SectionLayoutManagerCreator {
  func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager
}

class SectionLayoutManagerFactory: SectionLayoutManagerCreator {
  func createManager(type: SectionLayoutManagerType) -> SectionLayoutManager {
    switch type {
    case .home:
      return HomeViewSectionLayoutManager()
    case .campsiteDetail:
      return DetailViewCampsiteSectionLayoutManager()
    case .touristInfoDetail:
      return DetailViewTouristInfoSectionLayoutManager()
    }
  }
}


