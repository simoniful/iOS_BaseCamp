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
  private lazy var telCategoryLabel = StackingLabel(title: "문의처", font: .boldSystemFont(ofSize: 17.0))
  private lazy var telContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7)
  
  private lazy var homepageStack = makeStack(first: homepageCategoryLabel, second: homepageContentLabel, axis: .vertical)
  private lazy var homepageCategoryLabel = StackingLabel(title: "홈페이지", font: .boldSystemFont(ofSize: 17.0))
  private lazy var homepageContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7)
  
  private lazy var eventDateStack = makeStack(first: eventDateCategoryLabel, second: eventDateContentLabel, axis: .vertical)
  private lazy var eventDateCategoryLabel = StackingLabel(title: "행사 일정", font: .boldSystemFont(ofSize: 17.0))
  private lazy var eventDateContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7)
  
  private lazy var overviewStack = makeStack(first: overviewCategoryLabel, second: overviewContentLabel, axis: .vertical)
  private lazy var overviewCategoryLabel = StackingLabel(title: "소개말", font: .boldSystemFont(ofSize: 17.0))
  private lazy var overviewContentLabel = StackingLabel(title: "문의요망", font: .body2R16, textColor: .gray7)
  
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
    self.spacing = 4.0
  
    [telStack, homepageStack, eventDateStack, overviewStack].forEach {
      self.addArrangedSubview($0)
    }
  }
  
  func setData(data: DetailTouristInfoHeaderItem) {
    telContentLabel.text = data.tel.isEmpty ? "문의요망" : data.tel
    homepageContentLabel.text = data.homepage.isEmpty ? "문의요망" : data.homepage.htmlToString
    if let eventStartDate = data.eventStartDate,
       let eventEndDate = data.eventEndDate {
      eventDateContentLabel.text = "\(eventStartDate.toString(format: "yyyy-MM-dd")) ~ \(eventEndDate.toString(format: "yyyy-MM-dd"))"
    } else {
      eventDateStack.isHidden = true
    }
    overviewContentLabel.text = data.overview.isEmpty ? "문의요망" : data.overview.htmlToString
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
