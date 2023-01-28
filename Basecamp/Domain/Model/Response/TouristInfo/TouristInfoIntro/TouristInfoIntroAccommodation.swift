//
//  TouristInfoIntroAccommodation.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/28.
//

import Foundation

struct TouristInfoIntroAccommodation: TouristInfoIntro, PropertyIterable {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let roomcount, refundregulation: String
  let checkintime, checkouttime, chkcooking: String
  let subfacility: String
  let foodplace, reservationurl, pickup, infocenterlodging: String
  let parkinglodging, reservationlodging: String
}
