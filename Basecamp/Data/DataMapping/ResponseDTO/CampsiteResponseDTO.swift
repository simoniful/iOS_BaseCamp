//
//  CampsiteResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/21.
//

import Foundation

// MARK: - CampsiteResponseDTO
struct CampsiteResponseDTO: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
  let contentID, facltNm, lineIntro, intro: String?
  let allar, insrncAt, trsagntNo, bizrno: String?
  let facltDivNm, mangeDivNm, mgcDiv, manageSttus: String?
  let hvofBgnde, hvofEnddle, featureNm, induty: String?
  let lctCl, doNm, sigunguNm, zipcode: String?
  let addr1, addr2, mapX, mapY: String?
  let direction, tel: String?
  let homepage, resveURL: String?
  let resveCl, manageNmpr, gnrlSiteCo, autoSiteCo: String?
  let glampSiteCo, caravSiteCo, indvdlCaravSiteCo, sitedStnc: String?
  let siteMg1Width, siteMg2Width, siteMg3Width, siteMg1Vrticl: String?
  let siteMg2Vrticl, siteMg3Vrticl, siteMg1Co, siteMg2Co: String?
  let siteMg3Co, siteBottomCl1, siteBottomCl2, siteBottomCl3: String?
  let siteBottomCl4, siteBottomCl5: String?
  let tooltip, glampInnerFclty, caravInnerFclty, prmisnDe: String?
  let operPDCl, operDeCl, trlerAcmpnyAt, caravAcmpnyAt: String?
  let toiletCo, swrmCo, wtrplCo, brazierCl: String?
  let sbrsCl, sbrsEtc, posblFcltyCl, posblFcltyEtc: String?
  let clturEventAt, clturEvent, exprnProgrmAt, exprnProgrm: String?
  let extshrCo, frprvtWrppCo, frprvtSandCo, fireSensorCo: String?
  let themaEnvrnCl, eqpmnLendCl, animalCmgCl, tourEraCl: String?
  let firstImageURL: String?
  let createdtime, modifiedtime: String?
  
  enum CodingKeys: String, CodingKey {
    case contentID = "contentId"
    case facltNm, lineIntro, intro, allar, insrncAt, trsagntNo, bizrno, facltDivNm, mangeDivNm, mgcDiv, manageSttus, hvofBgnde, hvofEnddle, featureNm, induty, lctCl, doNm, sigunguNm, zipcode, addr1, addr2, mapX, mapY
    case direction, tel, homepage
    case resveURL = "resveUrl"
    case resveCl, manageNmpr, gnrlSiteCo, autoSiteCo, glampSiteCo, caravSiteCo, indvdlCaravSiteCo, sitedStnc, siteMg1Width, siteMg2Width, siteMg3Width, siteMg1Vrticl, siteMg2Vrticl, siteMg3Vrticl, siteMg1Co, siteMg2Co, siteMg3Co, siteBottomCl1, siteBottomCl2, siteBottomCl3, siteBottomCl4, siteBottomCl5
    case tooltip, glampInnerFclty, caravInnerFclty, prmisnDe
    case operPDCl = "operPdCl"
    case operDeCl, trlerAcmpnyAt, caravAcmpnyAt, toiletCo, swrmCo, wtrplCo, brazierCl, sbrsCl, sbrsEtc, posblFcltyCl, posblFcltyEtc, clturEventAt, clturEvent, exprnProgrmAt, exprnProgrm, extshrCo, frprvtWrppCo, frprvtSandCo, fireSensorCo, themaEnvrnCl, eqpmnLendCl, animalCmgCl, tourEraCl
    case firstImageURL = "firstImageUrl"
    case createdtime, modifiedtime
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.contentID = try? container.decodeIfPresent(String.self, forKey: .contentID)
    self.facltNm = try? container.decodeIfPresent(String.self, forKey: .facltNm)
    self.lineIntro = try? container.decodeIfPresent(String.self, forKey: .lineIntro)
    self.intro = try? container.decodeIfPresent(String.self, forKey: .intro)
    self.allar = try? container.decodeIfPresent(String.self, forKey: .allar)
    self.insrncAt = try? container.decodeIfPresent(String.self, forKey: .insrncAt)
    self.trsagntNo = try? container.decodeIfPresent(String.self, forKey: .trsagntNo)
    self.bizrno = try? container.decodeIfPresent(String.self, forKey: .bizrno)
    self.facltDivNm = try? container.decodeIfPresent(String.self, forKey: .facltDivNm)
    self.mangeDivNm = try? container.decodeIfPresent(String.self, forKey: .mangeDivNm)
    self.mgcDiv = try? container.decodeIfPresent(String.self, forKey: .mgcDiv)
    self.manageSttus = try? container.decodeIfPresent(String.self, forKey: .manageSttus)
    self.hvofBgnde = try? container.decodeIfPresent(String.self, forKey: .hvofBgnde)
    self.hvofEnddle = try? container.decodeIfPresent(String.self, forKey: .hvofEnddle)
    self.featureNm = try? container.decodeIfPresent(String.self, forKey: .featureNm)
    self.induty = try? container.decodeIfPresent(String.self, forKey: .induty)
    self.lctCl = try? container.decodeIfPresent(String.self, forKey: .lctCl)
    self.doNm = try? container.decodeIfPresent(String.self, forKey: .doNm)
    self.sigunguNm = try? container.decodeIfPresent(String.self, forKey: .sigunguNm)
    self.zipcode = try? container.decodeIfPresent(String.self, forKey: .zipcode)
    self.addr1 = try? container.decodeIfPresent(String.self, forKey: .addr1)
    self.addr2 = try? container.decodeIfPresent(String.self, forKey: .addr2)
    self.mapX = try? container.decodeIfPresent(String.self, forKey: .mapX)
    self.mapY = try? container.decodeIfPresent(String.self, forKey: .mapY)
    self.direction = try? container.decodeIfPresent(String.self, forKey: .direction)
    self.tel = try? container.decodeIfPresent(String.self, forKey: .tel)
    self.homepage = try? container.decodeIfPresent(String.self, forKey: .homepage)
    self.resveURL = try? container.decodeIfPresent(String.self, forKey: .resveURL)
    self.resveCl = try? container.decodeIfPresent(String.self, forKey: .resveCl)
    self.manageNmpr = try? container.decodeIfPresent(String.self, forKey: .manageNmpr)
    self.gnrlSiteCo = try? container.decodeIfPresent(String.self, forKey: .gnrlSiteCo)
    self.autoSiteCo = try? container.decodeIfPresent(String.self, forKey: .autoSiteCo)
    self.glampSiteCo = try? container.decodeIfPresent(String.self, forKey: .glampSiteCo)
    self.caravSiteCo = try? container.decodeIfPresent(String.self, forKey: .caravSiteCo)
    self.indvdlCaravSiteCo = try? container.decodeIfPresent(String.self, forKey: .indvdlCaravSiteCo)
    self.sitedStnc = try? container.decodeIfPresent(String.self, forKey: .sitedStnc)
    self.siteMg1Width = try? container.decodeIfPresent(String.self, forKey: .siteMg1Width)
    self.siteMg2Width = try? container.decodeIfPresent(String.self, forKey: .siteMg2Width)
    self.siteMg3Width = try? container.decodeIfPresent(String.self, forKey: .siteMg3Width)
    self.siteMg1Vrticl = try? container.decodeIfPresent(String.self, forKey: .siteMg1Vrticl)
    self.siteMg2Vrticl = try? container.decodeIfPresent(String.self, forKey: .siteMg2Vrticl)
    self.siteMg3Vrticl = try? container.decodeIfPresent(String.self, forKey: .siteMg3Vrticl)
    self.siteMg1Co = try? container.decodeIfPresent(String.self, forKey: .siteMg1Co)
    self.siteMg2Co = try? container.decodeIfPresent(String.self, forKey: .siteMg2Co)
    self.siteMg3Co = try? container.decodeIfPresent(String.self, forKey: .siteMg3Co)
    self.siteBottomCl1 = try? container.decodeIfPresent(String.self, forKey: .siteBottomCl1)
    self.siteBottomCl2 = try? container.decodeIfPresent(String.self, forKey: .siteBottomCl2)
    self.siteBottomCl3 = try? container.decodeIfPresent(String.self, forKey: .siteBottomCl3)
    self.siteBottomCl4 = try? container.decodeIfPresent(String.self, forKey: .siteBottomCl4)
    self.siteBottomCl5 = try? container.decodeIfPresent(String.self, forKey: .siteBottomCl5)
    self.tooltip = try? container.decodeIfPresent(String.self, forKey: .tooltip)
    self.glampInnerFclty = try? container.decodeIfPresent(String.self, forKey: .glampInnerFclty)
    self.caravInnerFclty = try? container.decodeIfPresent(String.self, forKey: .caravInnerFclty)
    self.prmisnDe = try? container.decodeIfPresent(String.self, forKey: .prmisnDe)
    self.operPDCl = try? container.decodeIfPresent(String.self, forKey: .operPDCl)
    self.operDeCl = try? container.decodeIfPresent(String.self, forKey: .operDeCl)
    self.trlerAcmpnyAt = try? container.decodeIfPresent(String.self, forKey: .trlerAcmpnyAt)
    self.caravAcmpnyAt = try? container.decodeIfPresent(String.self, forKey: .caravAcmpnyAt)
    self.toiletCo = try? container.decodeIfPresent(String.self, forKey: .toiletCo)
    self.swrmCo = try? container.decodeIfPresent(String.self, forKey: .swrmCo)
    self.wtrplCo = try? container.decodeIfPresent(String.self, forKey: .wtrplCo)
    self.brazierCl = try? container.decodeIfPresent(String.self, forKey: .brazierCl)
    self.sbrsCl = try? container.decodeIfPresent(String.self, forKey: .sbrsCl)
    self.sbrsEtc = try? container.decodeIfPresent(String.self, forKey: .sbrsEtc)
    self.posblFcltyCl = try? container.decodeIfPresent(String.self, forKey: .posblFcltyCl)
    self.posblFcltyEtc = try? container.decodeIfPresent(String.self, forKey: .posblFcltyEtc)
    self.clturEventAt = try? container.decodeIfPresent(String.self, forKey: .clturEventAt)
    self.clturEvent = try? container.decodeIfPresent(String.self, forKey: .clturEvent)
    self.exprnProgrmAt = try? container.decodeIfPresent(String.self, forKey: .exprnProgrmAt)
    self.exprnProgrm = try? container.decodeIfPresent(String.self, forKey: .exprnProgrm)
    self.extshrCo = try? container.decodeIfPresent(String.self, forKey: .extshrCo)
    self.frprvtWrppCo = try? container.decodeIfPresent(String.self, forKey: .frprvtWrppCo)
    self.frprvtSandCo = try? container.decodeIfPresent(String.self, forKey: .frprvtSandCo)
    self.fireSensorCo = try? container.decodeIfPresent(String.self, forKey: .fireSensorCo)
    self.themaEnvrnCl = try? container.decodeIfPresent(String.self, forKey: .themaEnvrnCl)
    self.eqpmnLendCl = try? container.decodeIfPresent(String.self, forKey: .eqpmnLendCl)
    self.animalCmgCl = try? container.decodeIfPresent(String.self, forKey: .animalCmgCl)
    self.tourEraCl = try? container.decodeIfPresent(String.self, forKey: .tourEraCl)
    self.firstImageURL = try? container.decodeIfPresent(String.self, forKey: .firstImageURL)
    self.createdtime = try? container.decodeIfPresent(String.self, forKey: .createdtime)
    self.modifiedtime = try? container.decodeIfPresent(String.self, forKey: .modifiedtime)
  }
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

extension CampsiteResponseDTO {
  func toDomain() -> [Campsite] {
    return response.body.items.item.map {
      $0.toDomain()
    }
  }
}

extension Item {
  func toDomain() -> Campsite {
    return .init(
      contentID: contentID,
      facltNm: facltNm,
      lineIntro: lineIntro,
      intro: intro,
      allar: allar,
      insrncAt: insrncAt,
      trsagntNo: trsagntNo,
      bizrno: bizrno,
      facltDivNm: facltDivNm,
      mangeDivNm: mangeDivNm,
      mgcDiv: mgcDiv,
      manageSttus: manageSttus,
      hvofBgnde: hvofBgnde,
      hvofEnddle: hvofEnddle,
      featureNm: featureNm,
      induty: induty,
      lctCl: lctCl,
      doNm: doNm,
      sigunguNm: sigunguNm,
      zipcode: zipcode,
      addr1: addr1,
      addr2: addr2,
      mapX: mapX,
      mapY: mapY,
      direction: direction,
      tel: tel,
      homepage: homepage,
      resveURL: resveURL,
      resveCl: resveCl,
      manageNmpr: manageNmpr,
      gnrlSiteCo: gnrlSiteCo,
      autoSiteCo: autoSiteCo,
      glampSiteCo: glampSiteCo,
      caravSiteCo: caravSiteCo,
      indvdlCaravSiteCo: indvdlCaravSiteCo,
      sitedStnc: sitedStnc,
      siteMg1Width: siteMg1Width,
      siteMg2Width: siteMg2Width,
      siteMg3Width: siteMg3Width,
      siteMg1Vrticl: siteMg1Vrticl,
      siteMg2Vrticl: siteMg2Vrticl,
      siteMg3Vrticl: siteMg3Vrticl,
      siteMg1Co: siteMg1Co,
      siteMg2Co: siteMg2Co,
      siteMg3Co: siteMg3Co,
      siteBottomCl1: siteBottomCl1,
      siteBottomCl2: siteBottomCl2,
      siteBottomCl3: siteBottomCl3,
      siteBottomCl4: siteBottomCl4,
      siteBottomCl5: siteBottomCl5,
      tooltip: tooltip,
      glampInnerFclty: glampInnerFclty,
      caravInnerFclty: caravInnerFclty,
      prmisnDe: prmisnDe,
      operPDCl: operPDCl,
      operDeCl: operDeCl,
      trlerAcmpnyAt: trlerAcmpnyAt,
      caravAcmpnyAt: caravAcmpnyAt,
      toiletCo: toiletCo,
      swrmCo: swrmCo,
      wtrplCo: wtrplCo,
      brazierCl: brazierCl,
      sbrsCl: sbrsCl,
      sbrsEtc: sbrsEtc,
      posblFcltyCl: posblFcltyCl,
      posblFcltyEtc: posblFcltyEtc,
      clturEventAt: clturEventAt,
      clturEvent: clturEvent,
      exprnProgrmAt: exprnProgrmAt,
      exprnProgrm: exprnProgrm,
      extshrCo: extshrCo,
      frprvtWrppCo: frprvtWrppCo,
      frprvtSandCo: frprvtSandCo,
      fireSensorCo: fireSensorCo,
      themaEnvrnCl: themaEnvrnCl,
      eqpmnLendCl: eqpmnLendCl,
      animalCmgCl: animalCmgCl,
      tourEraCl: tourEraCl,
      firstImageURL: firstImageURL,
      createdtime: createdtime,
      modifiedtime: modifiedtime
    )
  }
}

