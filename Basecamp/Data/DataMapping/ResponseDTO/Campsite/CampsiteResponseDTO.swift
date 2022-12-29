//
//  CampsiteResponseDTO.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/21.
//

import Foundation

// MARK: - CampsiteResponseDTO
struct CampsiteResponseDTO: Codable {
  let response: CampsiteResponseDTO_Response
}

// MARK: - Response
struct CampsiteResponseDTO_Response: Codable {
  let header: Header
  let body: CampsiteResponseDTO_Body
}

// MARK: - Body
struct CampsiteResponseDTO_Body: Codable {
  let items: CampsiteResponseDTO_Items
  let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CampsiteResponseDTO_Items: Codable {
  let item: [CampsiteResponseDTO_Item]
}

// MARK: - Item
struct CampsiteResponseDTO_Item: Codable {
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

extension CampsiteResponseDTO_Item {
  func toDomain() -> Campsite {
    return .init(
      contentID: contentID,
      facltNm: facltNm,
      lineIntro: lineIntro,
      intro: intro,
      manageSttus: manageSttus,
      facltDivNm: facltDivNm,
      induty: induty,
      lctCl: lctCl,
      doNm: doNm,
      sigunguNm: sigunguNm,
      addr1: addr1,
      mapX: mapX,
      mapY: mapY,
      direction: direction,
      tel: tel,
      homepage: homepage,
      resveCl: resveCl,
      gnrlSiteCo: gnrlSiteCo,
      autoSiteCo: autoSiteCo,
      glampSiteCo: glampSiteCo,
      caravSiteCo: caravSiteCo,
      indvdlCaravSiteCo: indvdlCaravSiteCo,
      tooltip: tooltip,
      glampInnerFclty: glampInnerFclty,
      caravInnerFclty: caravInnerFclty,
      operPDCl: operPDCl,
      operDeCl: operDeCl,
      brazierCl: brazierCl,
      sbrsCl: sbrsCl,
      sbrsEtc: sbrsEtc,
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
      firstImageURL: firstImageURL,
      modifiedtime: modifiedtime,
      isLiked: false
    )
  }
}

