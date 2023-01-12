//
//  TouristInfoIntroRestaurant.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoIntroRestaurant: TouristInfoIntro {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let seat, kidsfacility: String?
  let firstmenu, treatmenu, smoking, packing: String?
  let infocenterfood, scalefood, parkingfood, opendatefood: String?
  let opentimefood, restdatefood, discountinfofood, chkcreditcardfood: String?
  let reservationfood, lcnsno: String?
}
