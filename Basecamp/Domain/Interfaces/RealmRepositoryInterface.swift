//
//  RealmRepositoryInterface.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation
import RealmSwift

protocol RealmRepositoryInterface: AnyObject {

    func loadCampsite(matchedID: String) -> [Campsite]

    func createCampsite(campsite: Campsite, matchedID: String)

    func saveCampsiteList(campsites: [Campsite], matchedID: String)
}
