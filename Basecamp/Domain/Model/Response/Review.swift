//
//  Review.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/23.
//

import UIKit
import RealmSwift

struct Review {
  let _id: ObjectId
  let rate: Double
  let content: String
  let regDate: Date
  let startDate: Date
  let endDate: Date
  let campsite: Campsite
}
