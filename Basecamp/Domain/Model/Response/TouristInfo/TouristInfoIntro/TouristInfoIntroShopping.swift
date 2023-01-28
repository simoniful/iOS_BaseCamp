//
//  TouristInfoIntroShopping.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoIntroShopping: TouristInfoIntro, PropertyIterable {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let saleitem, saleitemcost: String
  let fairday, opendateshopping, shopguide, culturecenter: String
  let restroom, infocentershopping, scaleshopping, restdateshopping: String
  let parkingshopping, chkpetshopping, chkcreditcardshopping: String
  let opentime: String
}
