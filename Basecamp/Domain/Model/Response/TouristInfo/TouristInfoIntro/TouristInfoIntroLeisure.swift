//
//  TouristInfoIntroLeisure.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoIntroLeisure: TouristInfoIntro, PropertyIterable {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let openperiod, reservation: String
  let infocenterleports, accomcountleports, restdateleports: String
  let usetimeleports, usefeeleports, expagerangeleports, parkingleports: String
  let parkingfeeleports, chkpetleports, chkcreditcardleports: String
}


