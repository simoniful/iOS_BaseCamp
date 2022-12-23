//
//  Campsite.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

struct Campsite: HomeItem, Codable {
  let _id: String
  let contentID: String?
  let facltNm: String?
  let lineIntro: String?
  let intro: String?
  let manageSttus: String?
  let facltDivNm: String?
  let induty: String?
  let lctCl: String?
  let doNm: String?
  let sigunguNm: String?
  let addr1: String?
  let mapX: String?
  let mapY: String?
  let direction: String?
  let tel: String?
  let homepage: String?
  let resveCl: String?
  let gnrlSiteCo: String?
  let autoSiteCo: String?
  let glampSiteCo: String?
  let caravSiteCo: String?
  let indvdlCaravSiteCo: String?
  let tooltip: String?
  let glampInnerFclty: String?
  let caravInnerFclty: String?
  let operPDCl: String?
  let operDeCl: String?
  let brazierCl: String?
  let sbrsCl: String?
  let sbrsEtc: String?
  let clturEventAt: String?
  let clturEvent: String?
  let exprnProgrmAt: String?
  let exprnProgrm: String?
  let extshrCo: String?
  let frprvtWrppCo: String?
  let frprvtSandCo: String?
  let fireSensorCo: String?
  let themaEnvrnCl: String?
  let eqpmnLendCl: String?
  let animalCmgCl: String?
  let firstImageURL: String?
  let modifiedtime: String?
  var isLiked: Bool
}
