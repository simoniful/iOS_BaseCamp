//
//  CampsiteRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
// 에러를 통제하기 위함
import Moya

protocol CampsiteRepositoryInterface: AnyObject {
//   아마 추가적인 기입 정보 더 필요
  func requestCampsite() async -> Result<Campsite, Error>
}
