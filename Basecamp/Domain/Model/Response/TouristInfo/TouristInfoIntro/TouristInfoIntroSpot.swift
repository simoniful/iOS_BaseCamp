//
//  TouristInfoIntroSpot.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

protocol TouristInfoIntro {
  var contentId: Int? { get }
  var contentTypeId: TouristInfoContentType { get }
}

struct TouristInfoIntroSpot: TouristInfoIntro {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let infocenter: String?
  let opendate: String?
  let restdate: String?
  let expguide: String?
  let expagerange: String?
  let accomcount: String?
  let useseason: String?
  let usetime: String?
  let parking: String?
  let chkpet: String?
  let chkcreditcard: String?
}
