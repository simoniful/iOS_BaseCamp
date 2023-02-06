//
//  ReviewDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation
import RealmSwift

class ReviewDTO: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var rate: Double
  @Persisted var content: String
  @Persisted var regDate: Date
  @Persisted var visitDate: Date
  @Persisted var campsite: CampsiteRealmDTO?
  
  convenience init(rate: Double, content: String, regDate: Date, visitDate: Date, campsite: CampsiteRealmDTO) {
    self.init()
    self.rate = rate
    self.content = content
    self.regDate = regDate
    self.visitDate = visitDate
    self.campsite = campsite
  }
}

extension ReviewDTO {
  func toDomain() -> Review {
    return .init(
      _id: _id.stringValue,
      rate: rate,
      content: content,
      regDate: regDate,
      visitDate: visitDate,
      campsite: (campsite?.toDomain())!
    )
  }
}
