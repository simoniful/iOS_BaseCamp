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
import FSPagerView
import Kingfisher

final class DetailCampsiteHeaderCell: UICollectionViewCell {
  static let identifier = "DetailCampsiteHeaderCell"
  private var interactionSetFlag = false
  
  private var imageDataList = [String]()
  
  private(set) var disposeBag = DisposeBag()
  
  private lazy var pagerView: FSPagerView = {
    let pagerView = FSPagerView()
    pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "HeaderPagerViewCell")
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
    imageView.image = UIImage(named: "placeHolder")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var buttonStack: UIStackView = {
    let stackView = UIStackView()
    [callButton, reservationButton, visitButton, likeButton].forEach{ stackView.addArrangedSubview($0) }
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8.0
    stackView.layer.cornerRadius = 12.0
    // stackView.clipsToBounds = true
    // stackView.layer.borderColor = UIColor.systemGray2.cgColor
    stackView.backgroundColor = .systemGray6
 
    stackView.layer.shadowColor = UIColor.gray5.cgColor
    stackView.layer.shadowOpacity = 1.0
    stackView.layer.shadowOffset = CGSize.zero
    stackView.layer.shadowRadius = 1.0
    return stackView
  }()
  
  private lazy var callButton = makeButton(iconName: "phone", title: "전화")
  private lazy var reservationButton = makeButton(iconName: "calendar", title: "예약")
  private lazy var visitButton = makeButton(iconName: "flag", title: "방문")
  private lazy var likeButton = makeButton(iconName: "heart", title: "찜")
  
  private lazy var infoStack = DetailCampsiteHeaderStackView()

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

extension DetailCampsiteHeaderCell: ViewRepresentable {
  func setupView() {
    [placeholderImageView, pagerView, pagerControl, buttonStack, infoStack].forEach {
      contentView.addSubview($0)
    }
    pagerView.delegate = self
    pagerView.dataSource = self
    pagerControl.hidesForSinglePage = true
    pagerControl.contentHorizontalAlignment = .center
  }
  
  func setupConstraints() {
    placeholderImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.width / 4 * 3)
    }
    
    pagerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.width / 4 * 3)
    }
    
    pagerControl.snp.makeConstraints {
      $0.centerX.equalTo(placeholderImageView.snp.centerX)
      $0.bottom.equalTo(placeholderImageView.snp.bottom).offset(-10.0)
      $0.width.equalTo(80.0)
    }
    
    buttonStack.snp.makeConstraints {
      $0.top.equalTo(placeholderImageView.snp.bottom).offset(16.0)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.height.greaterThanOrEqualTo(80.0)
      $0.bottom.equalTo(infoStack.snp.top).offset(-16.0)
    }
    
    infoStack.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: DetailCampsiteHeaderItem) {
    infoStack.setData(data: data)
    
    if data.imageDataList.isEmpty {
      self.pagerView.isHidden = true
      self.pagerControl.isHidden = true
    } else {
      self.placeholderImageView.image = nil
    }
    
    if data.imageDataList.count < 7 {
      imageDataList = Array(data.imageDataList[data.imageDataList.indices])
    } else {
      imageDataList = Array(data.imageDataList[0..<7])
    }
  }
  
  func viewModel(item: DetailCampsiteHeaderItem) -> Observable<HeaderCellAction>? {
    if interactionSetFlag == false {
      interactionSetFlag.toggle()
      return Observable.merge(
        callButton.rx.tap
          .map({ _ in
            HeaderCellAction.call(item)
          }),
        reservationButton.rx.tap
          .map({ _ in
            HeaderCellAction.reserve(item)
          }),
        visitButton.rx.tap
          .map({ _ in
            HeaderCellAction.visit(item)
          }),
        likeButton.rx.tap
          .map({ _ in
            HeaderCellAction.like(item)
          })
      )
    }
    return nil
  }
  
  func makeButton(iconName: String, title: String) -> UIButton {
    let button = UIButton()
    button.setImage(UIImage(systemName: iconName), for: .normal)
    button.setTitle(title, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .darkGray
    button.titleLabel?.font = .body3R14
    button.setTitleColor(.darkGray, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
    button.alignTextBelow()
    return button
  }
}

extension DetailCampsiteHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
      pagerControl.numberOfPages = imageDataList.count
      return imageDataList.count
  }

  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HeaderPagerViewCell", at: index)
    let item =  imageDataList[index]
    let url = URL(string: item)
    let processor = DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 4 * 3))
    cell.imageView?.kf.indicatorType = .activity
    cell.imageView?.kf.setImage(
        with: url,
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    
    cell.imageView?.contentMode = .scaleAspectFill
    pagerControl.currentPage = index
    return cell
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let page = scrollView.contentOffset.x / scrollView.frame.width
      pagerControl.currentPage = Int(page)
  }

  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    let item = imageDataList[index]
  }
}

