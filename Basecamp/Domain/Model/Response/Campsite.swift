//
//  Campsite.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/16.
//

import Foundation

// 필요한 프로퍼티 기반으로 정리
struct Campsite: HomeItem, Codable {
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
}
