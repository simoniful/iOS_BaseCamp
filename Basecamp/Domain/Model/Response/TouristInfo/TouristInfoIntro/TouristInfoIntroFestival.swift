//
//  TouristInfoIntroFestival.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

struct TouristInfoIntroFestival: TouristInfoIntro {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let sponsor1, sponsor1Tel: String?
  let sponsor2, sponsor2Tel, eventEndDate, playtime: String?
  let eventplace, eventhomepage, agelimit, bookingplace: String?
  let placeinfo, subevent, program, eventStartDate: String?
  let usetimefestival, discountinfofestival, spendtimefestival: String?
}
