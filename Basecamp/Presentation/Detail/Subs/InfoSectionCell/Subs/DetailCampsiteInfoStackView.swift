//
//  CampsiteInfoStackView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/09.
//

import UIKit
import SnapKit

final class DetailCampsiteInfoStackView: UIStackView {
  private lazy var siteCoStack = makeStack(first: siteCoCategoryLabel, second: siteCoContentLabel, axis: .vertical)
  private lazy var siteCoCategoryLabel = StackingLabel(title: "주요시설", font: .boldSystemFont(ofSize: 17.0))
  private lazy var siteCoContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  
  private lazy var sbrsEtcStack = makeStack(first: sbrsEtcCategoryLabel, second: sbrsEtcContentLabel, axis: .vertical)
  private lazy var sbrsEtcCategoryLabel = StackingLabel(title: "기타 부대시설", font: .boldSystemFont(ofSize: 17.0))
  private lazy var sbrsEtcContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  
  private lazy var animalCmgClStack = makeStack(first: animalCmgClCategoryLabel, second: animalCmgClContentLabel, axis: .vertical)
  private lazy var animalCmgClCategoryLabel = StackingLabel(title: "반려동물 동반 여부", font: .boldSystemFont(ofSize: 17.0))
  private lazy var animalCmgClContentLabel = StackingLabel(title: "※ 실제 여부는 현장사정 및 계절에 따라 달라질 수 있으니 캠핑장 사업주에 직접 확인 후 이용바랍니다", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  private lazy var glampInnerFcltyStack = makeStack(first: glampInnerFcltyCategoryLabel, second: glampInnerFcltyContentLabel, axis: .vertical)
  private lazy var glampInnerFcltyCategoryLabel =  StackingLabel(title: "글램핑 내부시설", font: .boldSystemFont(ofSize: 17.0))
  private lazy var glampInnerFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  
  private lazy var caravInnerFcltyStack = makeStack(first: caravInnerFcltyCategoryLabel, second: caravInnerFcltyContentLabel, axis: .vertical)
  private lazy var caravInnerFcltyCategoryLabel =  StackingLabel(title: "카라반 내부시설", font: .boldSystemFont(ofSize: 17.0))
  private lazy var caravInnerFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  
  private lazy var brazierClStack = makeStack(first: brazierClCategoryLabel, second: brazierClContentLabel, axis: .vertical)
  private lazy var brazierClCategoryLabel = StackingLabel(title: "화로대", font: .boldSystemFont(ofSize: 17.0))
  private lazy var brazierClContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  
  private lazy var safetyFcltyStack = makeStack(first: safetyFcltyCategoryLabel, second: safetyFcltyContentLabel, axis: .vertical)
  private lazy var safetyFcltyCategoryLabel =  StackingLabel(title: "안전시설현황", font: .boldSystemFont(ofSize: 17.0))
  private lazy var safetyFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  private lazy var overviewStack = makeStack(first: overviewCategoryLabel, second: overviewContentLabel, axis: .vertical)
  private lazy var overviewCategoryLabel =  StackingLabel(title: "소개말", font: .boldSystemFont(ofSize: 17.0))
  private lazy var overviewContentLabel = StackingLabel(title: "문의요망", font: .body3R14, textColor: .gray7, padding: .init(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 0
    
    [siteCoStack, sbrsEtcStack, animalCmgClStack, glampInnerFcltyStack, caravInnerFcltyStack, brazierClStack, safetyFcltyStack, overviewStack].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailCampsiteInfoItem) {
    let defualtEmptyStr = NSMutableAttributedString()
      .brownColor("・ ")
      .regular(string: "문의요망", fontSize: 16)
    
    var siteCoStr = ""
    siteCoStr += data.gnrlSiteCo == "0" ? "" : "일반야영장(\(data.gnrlSiteCo)면) ・ "
    siteCoStr += data.autoSiteCo == "0" ? "" : "자동차야영장(\(data.autoSiteCo)면) ・ "
    siteCoStr += data.glampSiteCo == "0" ? "" : "글램핑시설(\(data.glampSiteCo)면) ・ "
    siteCoStr += data.caravSiteCo == "0" ? "" : "카라반사이트(\(data.caravSiteCo)면) ・ "
    
    let siteCoAttStr = NSMutableAttributedString()
      .regular(string: String(siteCoStr.dropLast(2)), fontSize: 14)
    
    siteCoContentLabel.attributedText = siteCoStr.isEmpty ? defualtEmptyStr : siteCoAttStr
    siteCoStack.isHidden = siteCoStr.isEmpty
    
    let sbrsEtcStr = NSMutableAttributedString()
      .regular(string: data.sbrsEtc.replacingOccurrences(of: ",", with: " ・ "), fontSize: 14)
    
    sbrsEtcContentLabel.attributedText = data.sbrsEtc.isEmpty ? defualtEmptyStr : sbrsEtcStr
    sbrsEtcStack.isHidden = data.sbrsEtc.isEmpty
    
    let animalCmgClEmptyStr = NSMutableAttributedString().regular(string: "※ 실제 여부는 현장사정 및 계절에 따라 달라질 수 있으니 캠핑장 사업주에 직접 확인 후 이용바랍니다", fontSize: 12)
    
    let animalCmgClStr = NSMutableAttributedString()
      .regular(string: data.animalCmgCl, fontSize: 14)
      .regular(string: "\n", fontSize: 4)
      .regular(string: "\n※ 실제 여부는 현장사정 및 계절에 따라 달라질 수 있으니 캠핑장 사업주에 직접 확인 후 이용바랍니다", fontSize: 11)
    
    animalCmgClContentLabel.attributedText = data.animalCmgCl.isEmpty ? animalCmgClEmptyStr : animalCmgClStr
    
    let glampInnerFcltyStr = NSMutableAttributedString()
      .regular(string: data.glampInnerFclty.replacingOccurrences(of: ",", with: " ・ "), fontSize: 14)
    
    glampInnerFcltyContentLabel.attributedText = data.glampInnerFclty.isEmpty ? defualtEmptyStr : glampInnerFcltyStr
    glampInnerFcltyStack.isHidden = data.glampInnerFclty.isEmpty
    
    let caravInnerFcltyStr = NSMutableAttributedString()
      .regular(string: data.caravInnerFclty.replacingOccurrences(of: ",", with: " ・ "), fontSize: 14)
    
    caravInnerFcltyContentLabel.attributedText = data.caravInnerFclty.isEmpty ? defualtEmptyStr : caravInnerFcltyStr
    caravInnerFcltyStack.isHidden = data.caravInnerFclty.isEmpty
    
    let brazierClStr = NSMutableAttributedString()
      .regular(string: data.brazierCl, fontSize: 14)
    
    brazierClContentLabel.attributedText = data.brazierCl.isEmpty ? defualtEmptyStr : brazierClStr
    brazierClStack.isHidden = data.brazierCl.isEmpty
    
    var safetyFcltyStr = ""
    safetyFcltyStr += data.extshrCo == "0" ? "" : "소화기(\(data.extshrCo)) ・ "
    safetyFcltyStr += data.frprvtWrppCo == "0" ? "" : "방화수(\(data.frprvtWrppCo)) ・ "
    safetyFcltyStr += data.frprvtSandCo == "0" ? "" : "방화사(\(data.frprvtSandCo)) ・ "
    safetyFcltyStr += data.fireSensorCo == "0" ? "" : "화재감지기(\(data.fireSensorCo)) ・ "

    let safetyFcltyAttStr = NSMutableAttributedString()
      .regular(string: String(safetyFcltyStr.dropLast(2)), fontSize: 14)
    
    safetyFcltyContentLabel.attributedText = safetyFcltyStr.isEmpty ? defualtEmptyStr : safetyFcltyAttStr
    safetyFcltyStack.isHidden = safetyFcltyStr.isEmpty
    
    overviewContentLabel.text = data.overview.isEmpty ? "소개말이 아직 작성되지 않았습니다" : data.overview
    overviewStack.isHidden = data.overview.isEmpty
  }
  
  private func makeStack(first: UIView, second: UIView, axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 0
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    [first, second].forEach {
      stackView.addArrangedSubview($0)
    }

    return stackView
  }
}
