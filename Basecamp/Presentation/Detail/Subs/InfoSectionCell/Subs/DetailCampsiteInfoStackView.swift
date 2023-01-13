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
  private lazy var siteCoCategoryLabel = StackingLabel(title: "주요시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var siteCoContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var sbrsEtcStack = makeStack(first: sbrsEtcCategoryLabel, second: sbrsEtcContentLabel, axis: .vertical)
  private lazy var sbrsEtcCategoryLabel = StackingLabel(title: "기타 부대시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var sbrsEtcContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var animalCmgClStack = makeStack(first: animalCmgClCategoryLabel, second: animalCmgClContentLabel, axis: .vertical)
  private lazy var animalCmgClCategoryLabel = StackingLabel(title: "반려동물 동반 여부", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var animalCmgClContentLabel = StackingLabel(title: "※ 실제 결과는 현장사정 및 계절에 따라 달라질 수 있으니 캠핑장 사업주에 직접 확인 후 이용바랍니다.", font: .body2R16)
  
  
  private lazy var glampInnerFcltyStack = makeStack(first: glampInnerFcltyCategoryLabel, second: glampInnerFcltyContentLabel, axis: .vertical)
  private lazy var glampInnerFcltyCategoryLabel =  StackingLabel(title: "글램핑 내부시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var glampInnerFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var caravInnerFcltyStack = makeStack(first: caravInnerFcltyCategoryLabel, second: caravInnerFcltyContentLabel, axis: .vertical)
  private lazy var caravInnerFcltyCategoryLabel =  StackingLabel(title: "카라반 내부시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var caravInnerFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var brazierClStack = makeStack(first: brazierClCategoryLabel, second: brazierClContentLabel, axis: .vertical)
  private lazy var brazierClCategoryLabel = StackingLabel(title: "화로대", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var brazierClContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var safetyFcltyStack = makeStack(first: safetyFcltyCategoryLabel, second: safetyFcltyContentLabel, axis: .vertical)
  private lazy var safetyFcltyCategoryLabel =  StackingLabel(title: "안전시설현황", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var safetyFcltyContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
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
    self.layer.cornerRadius = 8.0
    self.clipsToBounds = true
    self.layer.borderColor = UIColor.main.cgColor
    self.layer.borderWidth = 1.0
    
    [siteCoStack, sbrsEtcStack, animalCmgClStack, glampInnerFcltyStack, caravInnerFcltyStack, brazierClStack, safetyFcltyStack].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailCampsiteInfoItem) {
    var siteCoStr = ""
    siteCoStr += data.gnrlSiteCo == "0" ? "" : "일반야영장(\(data.gnrlSiteCo)면) • "
    siteCoStr += data.autoSiteCo == "0" ? "" : "자동차야영장(\(data.autoSiteCo)면) • "
    siteCoStr += data.glampSiteCo == "0" ? "" : "글램핑시설(\(data.glampSiteCo)면) • "
    siteCoStr += data.caravSiteCo == "0" ? "" : "카라반사이트(\(data.caravSiteCo)면) • "
    siteCoContentLabel.text = siteCoStr == "" ? "문의요망" : String(siteCoStr.dropLast(2))
 
    if data.sbrsEtc.isEmpty {
      sbrsEtcStack.isHidden = true
    } else {
      sbrsEtcContentLabel.text = data.sbrsEtc.replacingOccurrences(of: ",", with: " • ")
    }
 
    animalCmgClContentLabel.text = data.animalCmgCl.isEmpty ? "문의요망" : data.animalCmgCl
    
    if data.glampInnerFclty.isEmpty {
      glampInnerFcltyStack.isHidden = true
    } else {
      glampInnerFcltyContentLabel.text = data.glampInnerFclty.replacingOccurrences(of: ",", with: " • ")
    }
   
    if data.caravInnerFclty.isEmpty {
      caravInnerFcltyStack.isHidden = true
    } else {
      caravInnerFcltyContentLabel.text = data.caravInnerFclty.replacingOccurrences(of: ",", with: " • ")
    }
    
    if data.brazierCl.isEmpty {
      brazierClStack.isHidden = true
    } else {
      brazierClContentLabel.text = data.brazierCl
    }
    
    var safetyFcltyStr = ""
    safetyFcltyStr += data.extshrCo == "0" ? "" : "소화기(\(data.extshrCo)) • "
    safetyFcltyStr += data.frprvtWrppCo == "0" ? "" : "방화수(\(data.frprvtWrppCo)) • "
    safetyFcltyStr += data.frprvtSandCo == "0" ? "" : "방화사(\(data.frprvtSandCo)) • "
    safetyFcltyStr += data.fireSensorCo == "0" ? "" : "화재감지기(\(data.fireSensorCo)) • "

    if safetyFcltyStr == "" {
      safetyFcltyStack.isHidden = true
    } else {
      safetyFcltyContentLabel.text =  String(safetyFcltyStr.dropLast(2))
    }
  }
  
  private func makeStack(first: UIView, second: UIView, axis: NSLayoutConstraint.Axis) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 0
    
    [first, second].forEach {
      stackView.addArrangedSubview($0)
    }

    return stackView
  }
}
