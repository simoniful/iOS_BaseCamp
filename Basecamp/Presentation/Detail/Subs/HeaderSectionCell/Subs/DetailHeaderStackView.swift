//
//  InfoStackLabel.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/03.
//

import UIKit
import SnapKit

final class DetailHeaderStackView: UIStackView {
  
  private lazy var telStack = makeStack(first: telCategoryLabel, second: telContentLabel, axis: .vertical)
  
  private lazy var telCategoryLabel = DefaultLabel(title: "문의처", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var telContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  

  private lazy var campsiteTypeHStack = makeStack(first: lctClFacltDivNmStack, second: indutyStack, axis: .horizontal)
  
  private lazy var lctClFacltDivNmStack = makeStack(first: lctClFacltDivNmCategoryLabel, second: lctClFacltDivNmContentLabel, axis: .vertical)
  
  private lazy var lctClFacltDivNmCategoryLabel = DefaultLabel(title: "캠핑장 환경", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var lctClFacltDivNmContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  private lazy var indutyStack = makeStack(first: indutyCategoryLabel, second: indutyContentLabel, axis: .vertical)
  
  private lazy var indutyCategoryLabel = DefaultLabel(title: "캠핑장 유형", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var indutyContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var campsiteOperHStack = makeStack(first: operPDClStack, second: operDeClStack, axis: .horizontal)
  
  private lazy var operPDClStack = makeStack(first: operPDClCategoryLabel, second: operPDClContentLabel, axis: .vertical)

  private lazy var operPDClCategoryLabel = DefaultLabel(title: "운영기간", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var operPDClContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  private lazy var operDeClStack = makeStack(first: operDeClCategoryLabel, second: operDeClContentLabel, axis: .vertical)
  
  private lazy var operDeClCategoryLabel = DefaultLabel(title: "운영일", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var operDeClContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var homepageStack = makeStack(first: homepageCategoryLabel, second: homepageContentLabel, axis: .vertical)
  
  private lazy var homepageCategoryLabel = DefaultLabel(title: "홈페이지", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var homepageContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var posblFcltyClStack = makeStack(first: homepageCategoryLabel, second: homepageContentLabel, axis: .vertical)
  
  private lazy var posblFcltyClCategoryLabel = DefaultLabel(title: "주변이용가능시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var posblFcltyClContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  private lazy var resveClStack = makeStack(first: resveClCategoryLabel, second: resveClContentLabel, axis: .vertical)
  
  private lazy var resveClCategoryLabel = DefaultLabel(title: "예약방법", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var resveClContentLabel = DefaultLabel(title: "문의요망", font: .body2R16)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = true
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 0
    self.layer.cornerRadius = 8.0
    self.clipsToBounds = true
    self.layer.borderColor = UIColor.main.cgColor
    self.layer.borderWidth = 1.0
  
    [telStack, campsiteTypeHStack, campsiteOperHStack, homepageStack, posblFcltyClStack, resveClStack].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailCampsiteHeaderItem) {
    telContentLabel.text = data.tel.isEmpty ? "문의요망" : data.tel
    lctClFacltDivNmContentLabel.text = "\(data.lctCl.isEmpty ? "문의요망" : data.lctCl)/\(data.facltDivNm.isEmpty ? "문의요망" : data.facltDivNm)"
    indutyContentLabel.text = data.induty.isEmpty ? "문의요망" : data.induty
    operDeClContentLabel.text = data.operDeCl.isEmpty ? "문의요망" : data.operDeCl
    operPDClContentLabel.text = data.operPDCl.isEmpty ? "문의요망" : data.operPDCl
    homepageContentLabel.text = data.homepage.isEmpty ? "문의요망" : data.homepage
    posblFcltyClContentLabel.text = data.posblFcltyCl.isEmpty ? "문의요망" : data.posblFcltyCl
    resveClContentLabel.text = data.resveCl.isEmpty ? "문의요망" : data.resveCl
  }
  
  private func makeStack(first: UIView, second: UIView, axis:  NSLayoutConstraint.Axis) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 0
    
    [first, second].forEach {
      stackView.addArrangedSubview($0)
    }
    
    if axis == .vertical {
      first.snp.makeConstraints {
        $0.height.equalTo(36.0)
      }
      
      second.snp.makeConstraints {
        $0.height.equalTo(36.0)
      }
    }

    return stackView
  }
}
