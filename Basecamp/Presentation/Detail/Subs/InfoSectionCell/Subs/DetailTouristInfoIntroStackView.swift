//
//  DetailTouristInfoIntroStackView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/12.
//

import UIKit
import SnapKit

final class DetailTouristInfoIntroStackView: UIStackView {
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
  }
  
  func setData(data: any DetailTouristInfoIntroItem) {
    switch data.intro.contentTypeId {
    case .touristSpot:
      guard let convertedData = data.intro as? TouristInfoIntroSpot else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: (value as! String).htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .cultureFacilities:
      guard let convertedData = data.intro as? TouristInfoIntroCulture else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value as! String)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .festival:
      guard let convertedData = data.intro as? TouristInfoIntroFestival else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        let value = value as! String
        return makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value.htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .leisure:
      guard let convertedData = data.intro as? TouristInfoIntroLeisure else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        let value = value as! String
        return makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value.htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .accommodation:
      guard let convertedData = data.intro as? TouristInfoIntroAccommodation else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        let value = value as! String
        return makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value.htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .shoppingSpot:
      guard let convertedData = data.intro as? TouristInfoIntroShopping else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        let value = value as! String
        return makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value.htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    case .restaurant:
      guard let convertedData = data.intro as? TouristInfoIntroRestaurant else { return }
      let dataDic = convertedData.allProperties()
      let filetred = dataDic.filter {
        guard let value = $0.value as? String else { return false }
        return !(value.isEmpty)
      }
      let categories = filetred.map { (key, value) in
        let value = value as! String
        return makeCategory(category: data.intro.contentTypeId.introDic[key]!, content: value.htmlToString)
      }
      categories.forEach {
        self.addArrangedSubview($0)
      }
    }
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
  
  private func makeCategory(category: String, content: String) -> UIStackView {
    let categoryLabel = StackingLabel(title: category, font: .boldSystemFont(ofSize: 16.0), backgroundColor: .brown1)
    let contentLabel = StackingLabel(title: content, font: .body2R16)
    let category = makeStack(first: categoryLabel, second: contentLabel, axis: .vertical)
    return category
  }
}
