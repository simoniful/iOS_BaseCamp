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
  @Persisted var startDate: Date
  @Persisted var endDate: Date
  @Persisted var campsite: CampsiteRealmDTO?
  
  convenience init(review: Review) {
    self.init()
    self._id = review._id
    self.rate = review.rate
    self.content = review.content
    self.regDate = review.regDate
    self.startDate = review.startDate
    self.endDate = review.endDate
    self.campsite = CampsiteRealmDTO(campsite: review.campsite)
  }
}

extension ReviewDTO {
  func toDomain() -> Review {
    return .init(
      _id: _id,
      rate: rate,
      content: content,
      regDate: regDate,
      startDate: startDate,
      endDate: endDate,
      campsite: (campsite?.toDomain())!
    )
  }
}
