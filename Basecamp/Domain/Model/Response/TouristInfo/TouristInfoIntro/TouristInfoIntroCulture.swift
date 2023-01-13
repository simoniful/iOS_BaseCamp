//
//  TouristInfoIntroCulture.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoIntroCulture: TouristInfoIntro, PropertyIterable {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let usefee: String
  let discountinfo, spendtime, parkingfee, infocenterculture: String
  let accomcountculture, usetimeculture, restdateculture, parkingculture: String
  let chkpetculture, chkcreditcardculture: String

}

