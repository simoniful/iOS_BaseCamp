//
//  Dummy.swift
//  BasecampTests
//
//  Created by Sang hun Lee on 2023/02/23.
//

import Foundation
@testable import Basecamp

var campsiteDummyData: CampsiteResponseDTO = Dummy.share.load("CampsiteDummy.json")
var campsiteImageDummyData: CampsiteImageResponseDTO = Dummy.share.load("CampsiteImageDummy.json")

var touristInfoDummyData: TouristInfoResponseDTO = Dummy.share.load("TouristInfoDummy.json")
var touristInfoCommonDummyData: TouristInfoCommonResponseDTO = Dummy.share.load("TouristInfoCommonDummy.json")
var touristInfoIntroDummyData: TouristInfoIntroResponseDTO_SpotItem = Dummy.share.load("TouristInfoIntroDummy.json")
var touristInfoImageDummyData: TouristInfoImageResponseDTO = Dummy.share.load("TouristInfoImageDummy.json")
var touristInfoAreaCodeDummyData: TouristInfoAreaCodeResponseDTO = Dummy.share.load("TouristInfoAreaCodeDummy.json")

class Dummy {
  static let share = Dummy()
  
  func load<T: Decodable>(_ fileName: String) -> T {
    let data: Data
    let bundle = Bundle(for: type(of: self))
    
    guard let file = bundle.url(forResource: fileName, withExtension: nil) else {
      fatalError("\(fileName)을 main Bundle에서 불러올 수 없습니다.")
    }
    
    do {
      data = try Data(contentsOf: file)
    } catch {
      fatalError("\(fileName)을 main Bundle에서 불러올 수 없습니다. \(error)")
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      fatalError("\(fileName)을 \(T.self)로 파싱할 수 없습니다.")
    }
  }
}
