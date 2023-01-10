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
import Alamofire

final class DetailHeaderCell: UICollectionViewCell {
  static let identifier = "DetailHeaderCell"
  
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
    stackView.clipsToBounds = true
    stackView.layer.borderColor = UIColor.systemGray2.cgColor
    stackView.backgroundColor = .systemGray6
    return stackView
  }()
  
  private lazy var callButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "phone"), for: .normal)
    button.setTitle("전화", for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .darkGray
    button.titleLabel?.font = .body3R14
    button.setTitleColor(.darkGray, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var reservationButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "calendar"), for: .normal)
    button.setTitle("예약", for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .darkGray
    button.titleLabel?.font = .body3R14
    button.setTitleColor(.darkGray, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var visitButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "flag.fill"), for: .normal)
    button.setTitle("방문", for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .darkGray
    button.titleLabel?.font = .body3R14
    button.setTitleColor(.darkGray, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var likeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "heart"), for: .normal)
    button.setTitle("찜", for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .darkGray
    button.titleLabel?.font = .body3R14
    button.setTitleColor(.darkGray, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
    button.alignTextBelow()
    return button
  }()
  
  private lazy var infoStack = DetailHeaderStackView()

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
    [placeholderImageView, pagerView, pagerControl, buttonStack, infoStack].forEach {
      contentView.addSubview($0)
    }
    pagerView.delegate = self
    pagerView.dataSource = self
    pagerControl.hidesForSinglePage = true
    pagerControl.contentHorizontalAlignment = .right
  }
  
  func setupConstraints() {
    placeholderImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
    }
    
    pagerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
    }
    
    pagerControl.snp.makeConstraints {
      $0.centerX.equalTo(pagerView.snp.centerX)
      $0.bottom.equalTo(pagerView.snp.bottom).offset(-10.0)
      $0.width.equalTo(100.0)
    }
    
    buttonStack.snp.makeConstraints {
      $0.top.equalTo(placeholderImageView.snp.bottom).offset(16.0)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.height.equalTo(80.0)
    }
    
    infoStack.snp.makeConstraints {
      $0.top.equalTo(buttonStack.snp.bottom).offset(16.0)
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
}

extension DetailHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
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
    {
        result in
        switch result {
        case .success(let value):
            print("Task done for: \(value.source.url?.absoluteString ?? "")")
        case .failure(let error):
            print("Job failed: \(error.localizedDescription)")
        }
    }
    cell.imageView?.contentMode = .scaleAspectFill
    pagerControl.currentPage = index
    return cell
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let page = scrollView.contentOffset.x / scrollView.frame.width
      pagerControl.currentPage = Int(page)
  }

  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    let item =  imageDataList[index]
  }
}

