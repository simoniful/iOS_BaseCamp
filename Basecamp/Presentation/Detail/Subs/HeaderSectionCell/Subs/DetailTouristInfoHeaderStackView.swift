//
//  DetailTouristInfoHeaderStackView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/12.
//

import UIKit
import SnapKit

final class DetailTouristInfoHeaderStackView: UIStackView {
  
  private lazy var telStack = makeStack(first: telCategoryLabel, second: telContentLabel, axis: .vertical)
  
  private lazy var telCategoryLabel = StackingLabel(title: "문의처", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var telContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var campsiteTypeHStack = makeStack(first: lctClFacltDivNmStack, second: indutyStack, axis: .horizontal)
  
  private lazy var lctClFacltDivNmStack = makeStack(first: lctClFacltDivNmCategoryLabel, second: lctClFacltDivNmContentLabel, axis: .vertical)
  
  private lazy var lctClFacltDivNmCategoryLabel = StackingLabel(title: "캠핑장 환경", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var lctClFacltDivNmContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  private lazy var indutyStack = makeStack(first: indutyCategoryLabel, second: indutyContentLabel, axis: .vertical)
  
  private lazy var indutyCategoryLabel = StackingLabel(title: "캠핑장 유형", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var indutyContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var campsiteOperHStack = makeStack(first: operPDClStack, second: operDeClStack, axis: .horizontal)
  
  private lazy var operPDClStack = makeStack(first: operPDClCategoryLabel, second: operPDClContentLabel, axis: .vertical)

  private lazy var operPDClCategoryLabel = StackingLabel(title: "운영기간", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var operPDClContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  private lazy var operDeClStack = makeStack(first: operDeClCategoryLabel, second: operDeClContentLabel, axis: .vertical)
  
  private lazy var operDeClCategoryLabel = StackingLabel(title: "운영일", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var operDeClContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var homepageStack = makeStack(first: homepageCategoryLabel, second: homepageContentLabel, axis: .vertical)
  
  private lazy var homepageCategoryLabel = StackingLabel(title: "홈페이지", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var homepageContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
  private lazy var posblFcltyClStack = makeStack(first: homepageCategoryLabel, second: homepageContentLabel, axis: .vertical)
  
  private lazy var posblFcltyClCategoryLabel = StackingLabel(title: "주변이용가능시설", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var posblFcltyClContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  private lazy var resveClStack = makeStack(first: resveClCategoryLabel, second: resveClContentLabel, axis: .vertical)
  
  private lazy var resveClCategoryLabel = StackingLabel(title: "예약방법", font: .boldSystemFont(ofSize: 16.0), backgroundColor: .main)
  private lazy var resveClContentLabel = StackingLabel(title: "문의요망", font: .body2R16)
  
  
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
  
    [telStack, campsiteTypeHStack, campsiteOperHStack, homepageStack, posblFcltyClStack, resveClStack].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailTouristInfoHeaderItem) {

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