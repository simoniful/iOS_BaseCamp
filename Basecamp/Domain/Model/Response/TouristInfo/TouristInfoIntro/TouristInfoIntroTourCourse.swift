//
//  TouristInfoIntroTourCourse.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/02/09.
//

import Foundation

struct TouristInfoIntroTourCourse: TouristInfoIntro, PropertyIterable {
  let contentId: Int?
  let contentTypeId: TouristInfoContentType
  let infocentertourcourse, distance: String
  let schedule, taketime, theme: String
}
