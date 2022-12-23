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
    @Persisted var campsite: CampsiteRealmDTO
    
    convenience init(rate: Double, content: String, regDate: Date, campsite: CampsiteRealmDTO) {
        self.init()
        self.rate = rate
        self.content = content
        self.regDate = regDate
        self.campsite = campsite
    }
}
