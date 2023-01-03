//
//  DetailHeaderCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import EnumKit
import RxEnumKit
import RxFSPagerView

final class DetailHeaderCell: UICollectionViewCell {
  static let identifier = "DetailHeaderCell"
  private(set) var disposeBag = DisposeBag()
  
  private lazy var pagerView: FSPagerView = {
    let pagerView = FSPagerView()
    pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    pagerView.itemSize = FSPagerView.automaticSize
    pagerView.isInfinite = true
    pagerView.automaticSlidingInterval = 6.0
    return pagerView
  }()
  
  private lazy var pagerControl: FSPageControl = {
    let pageControl = FSPageControl()
    pageControl.hidesForSinglePage = true
    pageControl.contentHorizontalAlignment = .right
    return pageControl
  }()
  
  private lazy var placeholderImageView: UIImageView = {
    let imageView = UIImageView()
  }()
  
  private lazy var buttonStack: UIStackView = {
    let stackView = UIStackView()
    [callButton, reservationButton, visitButton, likeButton].forEach{ stackView.addArrangedSubview($0) }
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8.0
    stackView.layer.cornerRadius = 12.0
    stackView.clipsToBounds = true
    stackView.layer.borderColor = UIColor.systemGray2.cgColor
    stackView.backgroundColor = .systemGray6
    return stackView
  }()
  
  private lazy var callButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "phone"), for: .normal)
    button.setTitle("전화", for: .normal)
    button.contentMode = .scaleToFill
    button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var reservationButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "calendar"), for: .normal)
    button.setTitle("예약", for: .normal)
    button.contentMode = .scaleToFill
    button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var visitButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "flag.fill"), for: .normal)
    button.setTitle("방문", for: .normal)
    button.contentMode = .scaleToFill
    button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var likeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "heart"), for: .normal)
    button.setTitle("찜", for: .normal)
    button.contentMode = .scaleToFill
    button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var infoStack: UIStackView = {
    let stackView = UIStackView()
    [addressLabel, telLabel, lctClFacltDivNmLabel,
     indutyLabel, operPdClLabel, operDeClLabel,
     homepageLabel, resveClLabel, posblFcltyClLabel
    ].forEach{ stackView.addArrangedSubview($0) }
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    stackView.layer.cornerRadius = 8.0
    stackView.clipsToBounds = true
    stackView.layer.borderColor = UIColor.systemGray2.cgColor
    return stackView
  }()
  
  private lazy var addressLabel = InfoStackLabel()
  private lazy var telLabel = InfoStackLabel()
  private lazy var lctClFacltDivNmLabel = InfoStackLabel()
  private lazy var indutyLabel = InfoStackLabel()
  private lazy var operPdClLabel = InfoStackLabel()
  private lazy var operDeClLabel = InfoStackLabel()
  private lazy var homepageLabel = InfoStackLabel()
  private lazy var resveClLabel = InfoStackLabel()
  private lazy var posblFcltyClLabel = InfoStackLabel()
  
  override func layoutSubviews() {
      super.layoutSubviews()
      setupView()
      setupConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DetailHeaderCell: ViewRepresentable {
  func setupView() {
    [pagerView, pagerControl].forEach {
      addSubview($0)
    }
  }
  
  func setupConstraints() {
    
  }
