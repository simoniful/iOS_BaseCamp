//
//  constant.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import UIKit

struct WeatherStation {
    static let locationDic : [String : [Double]] = [
        "서울특별시" : [37.57142, 126.9658],
        "경기도" : [37.26399, 127.48421],
        "인천광역시": [37.47772, 126.6249],
        "강원도" : [37.90262, 127.7357],
        "대전광역시" : [36.37198, 127.37211],
        "세종특별자치시" : [36.48522, 127.24438],
        "광주광역시" : [35.17294, 126.89156],
        "대구광역시" : [35.87797, 128.65295],
        "부산광역시" : [35.10468, 129.03203],
        "울산광역시" : [35.58237, 129.33469],
        "제주특별자치도" : [33.51411, 126.52969],
        "충청북도" : [36.97045, 127.9525],
        "충청남도" : [36.76217, 127.29282],
        "경상북도" : [36.03201, 129.38002],
        "경상남도" : [35.16378, 128.04004],
        "전라북도" : [35.84092, 127.11718],
        "전라남도" : [34.81732, 126.38151]
    ]
}

struct AttractionType {
    static let attrationTypeDic: [String : Int] = [
        "관광지": 12,
        "문화시설": 14,
        "축제/행사": 15,
        "레져": 28,
        "맛집": 39,
        "쇼핑": 38
    ]
}

struct Size {
  static var screenW: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  static var screenH: CGFloat {
    return UIScreen.main.bounds.height
  }
}
