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
  let header: Header
  let body: TouristInfoIntroResponseDTO_Body<T>
}

struct TouristInfoIntroResponseDTO_Body<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let items: TouristInfoIntroResponseDTO_Items<T>
  let numOfRows, pageNo, totalCount: Int
}

struct TouristInfoIntroResponseDTO_Items<T: Codable & TouristInfoIntroResponseDTO_Item>: Codable {
  let item: [T]
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
    return TouristInfoIntroSpot(contentId: contentId, contentTypeId: contentTypeId, infocenter: infocenter, opendate: opendate, restdate: restdate, expguide: expguide, expagerange: expagerange, accomcount: accomcount, useseason: useseason, usetime: usetime, parking: parking, chkpet: chkpet, chkcreditcard: chkcreditcard)
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
    return TouristInfoIntroCulture(contentId: contentId, contentTypeId: contentTypeId, usefee: usefee, discountinfo: discountinfo, spendtime: spendtime, parkingfee: parkingfee, infocenterculture: infocenterculture, accomcountculture: accomcountculture, usetimeculture: usetimeculture, restdateculture: restdateculture, parkingculture: parkingculture, chkpetculture: chkpetculture, chkcreditcardculture: chkcreditcardculture)
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
    return TouristInfoIntroFestival(contentId: contentId, contentTypeId: contentTypeId, sponsor1: sponsor1, sponsor1Tel: sponsor1Tel, sponsor2: sponsor2, sponsor2Tel: sponsor2Tel, eventEndDate: eventEndDate, playtime: playtime, eventplace: eventplace, eventhomepage: eventhomepage, agelimit: agelimit, bookingplace: bookingplace, placeinfo: placeinfo, subevent: subevent, program: program, eventStartDate: eventStartDate, usetimefestival: usetimefestival, discountinfofestival: discountinfofestival, spendtimefestival: spendtimefestival)
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
    return TouristInfoIntroLeisure(contentId: contentId, contentTypeId: contentTypeId, openperiod: openperiod, reservation: reservation, infocenterleports: infocenterleports, accomcountleports: accomcountleports, restdateleports: restdateleports, usetimeleports: usetimeleports, usefeeleports: usefeeleports, expagerangeleports: expagerangeleports, parkingleports: parkingleports, parkingfeeleports: parkingfeeleports, chkpetleports: chkpetleports, chkcreditcardleports: chkcreditcardleports)
  }
}

struct TouristInfoIntroResponseDTO_RestaurantItem: Codable, TouristInfoIntroResponseDTO_Item {
  let contentId, contentTypeId: String?
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
  }
  
  func toDomain() -> TouristInfoIntro {
  }
}





