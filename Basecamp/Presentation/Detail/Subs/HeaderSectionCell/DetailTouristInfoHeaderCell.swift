//
//  DetailTouristInfoHeaderCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/12.
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

final class DetailTouristInfoHeaderCell: UICollectionViewCell {
  static let identifier = "DetailTouristInfoHeaderCell"
  private var imageDataList = [String]()
  public var disposeBag = DisposeBag()
  
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
  
  private lazy var infoStack = DetailTouristInfoHeaderStackView()
  
  private let pagerViewDidTapped = PublishRelay<String>()

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

extension DetailTouristInfoHeaderCell: ViewRepresentable {
  func setupView() {
    [placeholderImageView, pagerView, pagerControl, infoStack].forEach {
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
    
    infoStack.snp.makeConstraints {
      $0.top.equalTo(placeholderImageView.snp.bottom).offset(16.0)
      $0.leading.equalToSuperview().offset(16.0)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.bottom.equalToSuperview().offset(-16.0)
    }
  }
  
  func setupData(data: DetailTouristInfoHeaderItem) {
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
  
  func configure(with viewModel: DetailTouristInfoHeaderCellViewModel) {
    self.pagerViewDidTapped
      .bind(to: viewModel.pagerViewDidTapped)
      .disposed(by: disposeBag)
  }
}

extension DetailTouristInfoHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
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
    pagerViewDidTapped.accept(item)
  }
}

