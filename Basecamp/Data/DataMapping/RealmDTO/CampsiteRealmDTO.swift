//
//  CampsiteRealmDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation
import RealmSwift


class CampsiteRealmDTO: Object {
  @Persisted(primaryKey: true) var _id: String
  @Persisted var contentID: String?
  @Persisted var facltNm: String?
  @Persisted var lineIntro: String?
  @Persisted var intro: String?
  @Persisted var manageSttus: String?
  @Persisted var facltDivNm: String?
  @Persisted var induty: String?
  @Persisted var lctCl: String?
  @Persisted var doNm: String?
  @Persisted var sigunguNm: String?
  @Persisted var addr1: String?
  @Persisted var mapX: String?
  @Persisted var mapY: String?
  @Persisted var direction: String?
  @Persisted var tel: String?
  @Persisted var homepage: String?
  @Persisted var resveCl: String?
  @Persisted var gnrlSiteCo: String?
  @Persisted var autoSiteCo: String?
  @Persisted var glampSiteCo: String?
  @Persisted var caravSiteCo: String?
  @Persisted var indvdlCaravSiteCo: String?
  @Persisted var tooltip: String?
  @Persisted var glampInnerFclty: String?
  @Persisted var caravInnerFclty: String?
  @Persisted var operPDCl: String?
  @Persisted var operDeCl: String?
  @Persisted var brazierCl: String?
  @Persisted var sbrsCl: String?
  @Persisted var sbrsEtc: String?
  @Persisted var clturEventAt: String?
  @Persisted var clturEvent: String?
  @Persisted var exprnProgrmAt: String?
  @Persisted var exprnProgrm: String?
  @Persisted var extshrCo: String?
  @Persisted var frprvtWrppCo: String?
  @Persisted var frprvtSandCo: String?
  @Persisted var fireSensorCo: String?
  @Persisted var themaEnvrnCl: String?
  @Persisted var eqpmnLendCl: String?
  @Persisted var animalCmgCl: String?
  @Persisted var firstImageURL: String?
  @Persisted var modifiedtime: String?
  @Persisted var isLiked: Bool
  
  convenience init(campsite: Campsite) {
    self.init()
    self._id = campsite._id
    self.contentID = campsite.contentID
    self.facltNm = campsite.facltNm
    self.lineIntro = campsite.lineIntro
    self.intro = campsite.intro
    self.manageSttus = campsite.manageSttus
    self.facltDivNm = campsite.facltDivNm
    self.induty = campsite.induty
    self.lctCl = campsite.lctCl
    self.doNm = campsite.doNm
    self.sigunguNm = campsite.sigunguNm
    self.addr1 = campsite.addr1
    self.mapX = campsite.mapX
    self.mapY = campsite.mapY
    self.direction = campsite.direction
    self.tel = campsite.tel
    self.homepage = campsite.homepage
    self.resveCl = campsite.resveCl
    self.gnrlSiteCo = campsite.gnrlSiteCo
    self.autoSiteCo = campsite.autoSiteCo
    self.glampSiteCo = campsite.glampSiteCo
    self.caravSiteCo = campsite.caravSiteCo
    self.indvdlCaravSiteCo = campsite.indvdlCaravSiteCo
    self.tooltip = campsite.tooltip
    self.glampInnerFclty = campsite.glampInnerFclty
    self.caravInnerFclty = campsite.caravInnerFclty
    self.operPDCl = campsite.operPDCl
    self.operDeCl = campsite.operDeCl
    self.brazierCl = campsite.brazierCl
    self.sbrsCl = campsite.sbrsCl
    self.sbrsEtc = campsite.sbrsEtc
    self.clturEventAt = campsite.clturEventAt
    self.clturEvent = campsite.clturEvent
    self.exprnProgrmAt = campsite.exprnProgrmAt
    self.exprnProgrm = campsite.exprnProgrm
    self.extshrCo = campsite.extshrCo
    self.frprvtWrppCo = campsite.frprvtWrppCo
    self.frprvtSandCo = campsite.frprvtSandCo
    self.fireSensorCo = campsite.fireSensorCo
    self.themaEnvrnCl = campsite.themaEnvrnCl
    self.eqpmnLendCl = campsite.eqpmnLendCl
    self.animalCmgCl = campsite.animalCmgCl
    self.firstImageURL = campsite.firstImageURL
    self.modifiedtime = campsite.modifiedtime
    self.isLiked = campsite.isLiked
  }
}

extension CampsiteRealmDTO {
  func toDomain() -> Campsite {
    return .init(
      _id: <#T##String#>,
      contentID: <#T##String?#>,
      facltNm: <#T##String?#>,
      lineIntro: <#T##String?#>,
      intro: <#T##String?#>,
      manageSttus: <#T##String?#>,
      facltDivNm: <#T##String?#>,
      induty: <#T##String?#>,
      lctCl: <#T##String?#>,
      doNm: <#T##String?#>,
      sigunguNm: <#T##String?#>,
      addr1: <#T##String?#>,
      mapX: <#T##String?#>,
      mapY: <#T##String?#>,
      direction: <#T##String?#>,
      tel: <#T##String?#>,
      homepage: <#T##String?#>,
      resveCl: <#T##String?#>,
      gnrlSiteCo: <#T##String?#>,
      autoSiteCo: <#T##String?#>,
      glampSiteCo: <#T##String?#>,
      caravSiteCo: <#T##String?#>,
      indvdlCaravSiteCo: <#T##String?#>,
      tooltip: <#T##String?#>,
      glampInnerFclty: <#T##String?#>,
      caravInnerFclty: <#T##String?#>,
      operPDCl: <#T##String?#>,
      operDeCl: <#T##String?#>,
      brazierCl: <#T##String?#>,
      sbrsCl: <#T##String?#>,
      sbrsEtc: <#T##String?#>,
      clturEventAt: <#T##String?#>,
      clturEvent: <#T##String?#>,
      exprnProgrmAt: <#T##String?#>,
      exprnProgrm: <#T##String?#>,
      extshrCo: <#T##String?#>,
      frprvtWrppCo: <#T##String?#>,
      frprvtSandCo: <#T##String?#>,
      fireSensorCo: <#T##String?#>,
      themaEnvrnCl: <#T##String?#>,
      eqpmnLendCl: <#T##String?#>,
      animalCmgCl: <#T##String?#>,
      firstImageURL: <#T##String?#>,
      modifiedtime: <#T##String?#>,
      isLiked: <#T##Bool#>
    )
  }
}
