//
//  TouristInfoIntroResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/29.
//

import Foundation

struct TouristInfoIntroResponseDTO<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let response: TouristInfoIntroResponseDTO_Response<T>
}

struct TouristInfoIntroResponseDTO_Response<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let header: TouristInfoResponseDTO_Header
  let body: TouristInfoIntroResponseDTO_Body<T>
}

struct TouristInfoIntroResponseDTO_Body<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let items: TouristInfoIntroResponseDTO_Items<T>
  let numOfRows, pageNo, totalCount: Int
}

struct TouristInfoIntroResponseDTO_Items<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let item: [T]
}

extension TouristInfoIntroResponseDTO {
  func toDomain() -> [TouristInfoIntro] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

protocol TouristInfoIntroResponseDTO_Item: Codable {
  var contentId: String? { get }
  var contentTypeId: String? { get }
  func toDomain() -> TouristInfoIntro
}

struct TouristInfoIntroResponseDTO_SpotItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId: String?
  let contentTypeId: String?
  let heritage1, heritage2: String?
  let heritage3, infocenter, opendate, restdate: String?
  let expguide, expagerange, accomcount, useseason: String?
  let usetime, parking, chkbabycarriage, chkpet: String?
  let chkcreditcard: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case heritage1, heritage2, heritage3
    case infocenter, opendate, restdate
    case expguide, expagerange, accomcount, useseason
    case usetime, parking, chkbabycarriage, chkpet
    case chkcreditcard
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroSpot(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      infocenter: infocenter ?? "",
      opendate: opendate ?? "",
      restdate: restdate ?? "",
      expguide: expguide ?? "",
      expagerange: expagerange ?? "",
      accomcount: accomcount ?? "",
      useseason: useseason ?? "",
      usetime: usetime ?? "",
      parking: parking ?? "",
      chkpet: chkpet ?? "",
      chkcreditcard: chkcreditcard ?? ""
    )
  }
}

struct TouristInfoIntroResponseDTO_CultureItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId: String?
  let contentTypeId: String?
  let scale, usefee: String?
  let discountinfo, spendtime, parkingfee, infocenterculture: String?
  let accomcountculture, usetimeculture, restdateculture, parkingculture: String?
  let chkbabycarriageculture, chkpetculture, chkcreditcardculture: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case scale, usefee, discountinfo, spendtime, parkingfee, infocenterculture, accomcountculture, usetimeculture, restdateculture, parkingculture, chkbabycarriageculture, chkpetculture, chkcreditcardculture
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroCulture(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      usefee: usefee ?? "",
      discountinfo: discountinfo ?? "",
      spendtime: spendtime ?? "",
      parkingfee: parkingfee ?? "",
      infocenterculture: infocenterculture ?? "",
      accomcountculture: accomcountculture ?? "",
      usetimeculture: usetimeculture ?? "",
      restdateculture: restdateculture ?? "",
      parkingculture: parkingculture ?? "",
      chkpetculture: chkpetculture ?? "",
      chkcreditcardculture: chkcreditcardculture ?? ""
    )
  }
}

struct TouristInfoIntroResponseDTO_FestivalItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId, sponsor1, sponsor1Tel: String?
  let sponsor2, sponsor2Tel, eventEndDate, playtime: String?
  let eventplace, eventhomepage, agelimit, bookingplace: String?
  let placeinfo, subevent, program, eventStartDate: String?
  let usetimefestival, discountinfofestival, spendtimefestival, festivalgrade: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case sponsor1, sponsor1Tel, sponsor2, sponsor2Tel
    case eventEndDate = "eventenddate"
    case playtime, eventplace, eventhomepage, agelimit, bookingplace, placeinfo, subevent, program
    case eventStartDate = "eventstartdate"
    case usetimefestival, discountinfofestival, spendtimefestival,
         festivalgrade
  }

  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroFestival(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      sponsor1: sponsor1 ?? "",
      sponsor1Tel: sponsor1Tel ?? "",
      sponsor2: sponsor2 ?? "",
      sponsor2Tel: sponsor2Tel ?? "",
      eventEndDate: eventEndDate ?? "",
      playtime: playtime ?? "",
      eventplace: eventplace ?? "",
      eventhomepage: eventhomepage ?? "",
      agelimit: agelimit ?? "",
      bookingplace: bookingplace ?? "",
      placeinfo: placeinfo ?? "",
      subevent: subevent ?? "",
      program: program ?? "",
      eventStartDate: eventStartDate ?? "",
      usetimefestival: usetimefestival ?? "",
      discountinfofestival: discountinfofestival ?? "",
      spendtimefestival: spendtimefestival ?? ""
    )
  }
}

struct TouristInfoIntroResponseDTO_LeisureItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId: String?
  let openperiod, reservation: String?
  let infocenterleports, scaleleports, accomcountleports, restdateleports: String?
  let usetimeleports, usefeeleports, expagerangeleports, parkingleports: String?
  let parkingfeeleports, chkbabycarriageleports, chkpetleports, chkcreditcardleports: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case openperiod, reservation, infocenterleports, scaleleports, accomcountleports, restdateleports, usetimeleports, usefeeleports, expagerangeleports, parkingleports, parkingfeeleports, chkbabycarriageleports, chkpetleports, chkcreditcardleports
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroLeisure(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      openperiod: openperiod ?? "",
      reservation: reservation ?? "",
      infocenterleports: infocenterleports ?? "",
      accomcountleports: accomcountleports ?? "",
      restdateleports: restdateleports ?? "",
      usetimeleports: usetimeleports ?? "",
      usefeeleports: usefeeleports ?? "",
      expagerangeleports: expagerangeleports ?? "",
      parkingleports: parkingleports ?? "",
      parkingfeeleports: parkingfeeleports ?? "",
      chkpetleports: chkpetleports ?? "",
      chkcreditcardleports: chkcreditcardleports ?? ""
    )
  }
}

// 실제 json과 비교하여 구조체 구성
struct TouristInfoIntroResponseDTO_AccommodationItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId, goodstay, benikia: String?
  let hanok, roomcount, roomtype, refundregulation: String?
  let checkintime, checkouttime, chkcooking, seminar: String?
  let sports, sauna, beauty, beverage: String?
  let karaoke, barbecue, campfire, bicycle: String?
  let fitness, publicpc, publicbath, subfacility: String?
  let foodplace, reservationurl, pickup, infocenterlodging: String?
  let parkinglodging, reservationlodging, scalelodging, accomcountlodging: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case goodstay, benikia, hanok, roomcount, roomtype, refundregulation, checkintime, checkouttime, chkcooking, seminar, sports, sauna, beauty, beverage, karaoke, barbecue, campfire, bicycle, fitness, publicpc, publicbath, subfacility, foodplace, reservationurl, pickup, infocenterlodging, parkinglodging, reservationlodging, scalelodging, accomcountlodging
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroAccommodation(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      roomcount: roomcount ?? "",
      refundregulation: refundregulation ?? "",
      checkintime: checkintime ?? "",
      checkouttime: checkouttime ?? "",
      chkcooking: chkcooking ?? "",
      subfacility: subfacility ?? "",
      foodplace: foodplace ?? "",
      reservationurl: reservationurl ?? "",
      pickup: pickup ?? "",
      infocenterlodging: infocenterlodging ?? "",
      parkinglodging: parkinglodging ?? "",
      reservationlodging: reservationlodging ?? ""
    )
  }
}

struct TouristInfoIntroResponseDTO_ShoppingItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId: String?
  let saleitem, saleitemcost: String?
  let fairday, opendateshopping, shopguide, culturecenter: String?
  let restroom, infocentershopping, scaleshopping, restdateshopping: String?
  let parkingshopping, chkpetshopping, chkcreditcardshopping: String?
  let opentime: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case saleitem, saleitemcost, fairday, opendateshopping, shopguide, culturecenter, restroom, infocentershopping, scaleshopping, restdateshopping, parkingshopping, chkpetshopping, chkcreditcardshopping, opentime
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroShopping(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      saleitem: saleitem ?? "",
      saleitemcost: saleitemcost ?? "",
      fairday: fairday ?? "",
      opendateshopping: opendateshopping ?? "",
      shopguide: shopguide ?? "",
      culturecenter: culturecenter ?? "",
      restroom: restroom ?? "",
      infocentershopping: infocentershopping ?? "",
      scaleshopping: scaleshopping ?? "",
      restdateshopping: restdateshopping ?? "",
      parkingshopping: parkingshopping ?? "",
      chkpetshopping: chkpetshopping ?? "",
      chkcreditcardshopping: chkcreditcardshopping ?? "",
      opentime: opentime ?? ""
    )
  }
}

struct TouristInfoIntroResponseDTO_RestaurantItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId: String?
  let seat, kidsfacility: String?
  let firstmenu, treatmenu, smoking, packing: String?
  let infocenterfood, scalefood, parkingfood, opendatefood: String?
  let opentimefood, restdatefood, discountinfofood, chkcreditcardfood: String?
  let reservationfood, lcnsno: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case seat, kidsfacility, firstmenu, treatmenu, smoking, packing, infocenterfood, scalefood, parkingfood, opendatefood, opentimefood, restdatefood, discountinfofood, chkcreditcardfood, reservationfood, lcnsno
  }
  
  func toDomain() -> TouristInfoIntro {
    return TouristInfoIntroRestaurant(
      contentId: Int(contentId!),
      contentTypeId: TouristInfoContentType(rawValue: Int(contentTypeId!)!)!,
      seat: seat ?? "",
      kidsfacility: kidsfacility ?? "",
      firstmenu: firstmenu ?? "",
      treatmenu: treatmenu ?? "",
      smoking: smoking ?? "",
      packing: packing ?? "",
      infocenterfood: infocenterfood ?? "",
      scalefood: scalefood ?? "",
      parkingfood: parkingfood ?? "",
      opendatefood: opendatefood ?? "",
      opentimefood: opentimefood ?? "",
      restdatefood: restdatefood ?? "",
      discountinfofood: discountinfofood ?? "",
      chkcreditcardfood: chkcreditcardfood ?? "",
      reservationfood: reservationfood ?? "",
      lcnsno: lcnsno ?? ""
    )
  }
}







