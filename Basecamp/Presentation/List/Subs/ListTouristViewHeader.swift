//
//  ListTouristViewHeader.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/26.
//

import UIKit
import SnapKit
import TTGTags

protocol ListTouristViewHeaderDelegate: AnyObject {
  func didSelectTag(_ selected: TouristInfoContentType?)
}

final class ListTouristViewHeader: UITableViewHeaderFooterView {
  static let identifier = "ListTouristViewHeader"
  private var currentIndex: UInt = 0
  
  private weak var delegate: ListTouristViewHeaderDelegate?
  
  private lazy var tagCollectionView = TTGTextTagCollectionView()
  private lazy var tags = TouristInfoContentType.allCases
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
    setupTagCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(delegate: ListTouristViewHeaderDelegate) {
    self.delegate = delegate
  }
}

extension ListTouristViewHeader: ViewRepresentable {
  func setupView() {
    addSubview(tagCollectionView)
    contentView.backgroundColor = .systemBackground
  }
  
  func setupConstraints() {
    tagCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension ListTouristViewHeader: TTGTextTagCollectionViewDelegate {
  func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
    guard tag.selected else {
      delegate?.didSelectTag(nil)
      return
    }
    currentIndex = index
    delegate?.didSelectTag(tags[Int(index)])
  }
  
  func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
    if index != currentIndex {
      tagCollectionView.updateTag(at: currentIndex, selected: false)
      tagCollectionView.reload()
    }
    return true
  }
}

private extension ListTouristViewHeader {
  func setupTagCollectionView() {
    tagCollectionView.delegate = self
    
    let insetValue: CGFloat = 16.0
    let cornerRadiusValue: CGFloat = 12.0
    let shadowOpacityValue: CGFloat = 0.0
    let extraSpaceValue: CGSize = CGSize(width: 20.0, height: 12.0)
    let colorValue: UIColor = .main
    
    let style = TTGTextTagStyle()
    style.backgroundColor = colorValue
    style.cornerRadius = cornerRadiusValue
    style.borderWidth = 0.0
    style.shadowOpacity = shadowOpacityValue
    style.extraSpace = extraSpaceValue
    
    let selectedStyle = TTGTextTagStyle()
    selectedStyle.backgroundColor = .white
    selectedStyle.cornerRadius = cornerRadiusValue
    selectedStyle.borderColor = colorValue
    selectedStyle.shadowOpacity = shadowOpacityValue
    selectedStyle.extraSpace = extraSpaceValue
    
    tagCollectionView.numberOfLines = 1
    tagCollectionView.scrollDirection = .horizontal
    tagCollectionView.showsHorizontalScrollIndicator = false
    tagCollectionView.selectionLimit = 1
    
    tagCollectionView.contentInset = UIEdgeInsets(
      top: insetValue,
      left: insetValue,
      bottom: insetValue,
      right: insetValue
    )
    
    tags.forEach {
      let fontValue = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
      let tagContent = TTGTextTagStringContent(
        text: $0.koreanTitle,
        textFont: fontValue,
        textColor: .white
      )
      
      let selectedTagContent = TTGTextTagStringContent(
        text: $0.koreanTitle,
        textFont: fontValue,
        textColor: colorValue
      )
      
      let tag = TTGTextTag(
        content: tagContent,
        style: style,
        selectedContent: selectedTagContent,
        selectedStyle: selectedStyle
      )
      tagCollectionView.addTag(tag)
    }
    tagCollectionView.reload()
  }
}
