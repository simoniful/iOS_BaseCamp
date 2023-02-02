//
//  HomeHeaderView.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import EnumKit
import RxEnumKit

final class HomeHeaderCell: UICollectionViewCell {
  static let identifier = "HomeHeaderCell"
  private(set) var disposeBag = DisposeBag()
  private var interactionSetFlag = false
  
  private lazy var myCompView: UIView = {
    let view = UIView()
    [myCompTitleLabel, myCompArrowImage, myCompContentLabel].forEach {
      view.addSubview($0)
    }
    return view
  }()
  
  private lazy var myCompTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "캠핑 로그를 기록해 보세요."
    label.font = .systemFont(ofSize: 22, weight: .bold)
    return label
  }()
  
  private lazy var myCompArrowImage: UIImageView = {
    let image = UIImage(named: "arrow.right")
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var myCompContentLabel: UILabel = {
    let label = UILabel()
    label.text = "현재까지 0곳을 방문하고, 0곳을 후보지로 찜하셨어요!"
    label.font = .title3M14
    label.textAlignment = .center
    label.textColor = .white
    label.backgroundColor = .brown2
    label.layer.cornerRadius = 8.0
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var mapCompView: UIImageView = {
    let imageView = UIImageView(image: UIImage())
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
    imageView.tintColor = .orange
    return imageView
  }()
  
  private lazy var searchCompView: UIImageView = {
    let imageView = UIImageView(image: UIImage())
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
    imageView.tintColor = .orange
    return imageView
  }()
  
  private lazy var compStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.addArrangedSubview(mapCompView)
    stackView.addArrangedSubview(searchCompView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8.0
    return stackView
  }()
  
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

extension HomeHeaderCell: ViewRepresentable {
  func setupView() {
    [myCompView, compStackView].forEach {
      addSubview($0)
    }
  }
  
  func setupConstraints() {
    myCompView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    myCompView.setContentHuggingPriority(.init(rawValue: 751), for: .vertical)
    
    myCompTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.leading.equalToSuperview()
      $0.height.equalTo(24.0)
    }
    
    myCompArrowImage.snp.makeConstraints {
      $0.centerY.equalTo(myCompTitleLabel.snp.centerY)
      $0.trailing.equalToSuperview()
      $0.height.width.equalTo(14)
    }
    
    myCompContentLabel.snp.makeConstraints {
      $0.top.equalTo(myCompTitleLabel.snp.bottom).offset(16.0)
      $0.leading.equalToSuperview()
      $0.height.equalTo(26.0)
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-8)
    }
    
    compStackView.snp.makeConstraints {
      $0.top.equalTo(myCompView.snp.bottom).offset(8.0)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    compStackView.setContentHuggingPriority(.init(rawValue: 750), for: .vertical)
  }
  
  func setupData(completedCount: Int, likedCount: Int) {
    self.myCompContentLabel.text = "현재까지 \(completedCount)곳을 방문하고, \(likedCount)곳을 후보지로 찜하셨어요!"
  }
  
  func viewModel(item: HomeHeaderItem) -> Observable<HeaderCellAction>? {
    if interactionSetFlag == false {
      interactionSetFlag.toggle()
      return Observable.merge(
        myCompView.rx.tapGesture()
          .when(.recognized)
          .map({ _ in
            HeaderCellAction.myMenu(item)
          }),
        mapCompView.rx.tapGesture()
          .when(.recognized)
          .map({ _ in
            HeaderCellAction.map(item)
          }),
        searchCompView.rx.tapGesture()
          .when(.recognized)
          .map({ _ in
            HeaderCellAction.search(item)
          })
      )
    }
    return nil
  }
}

enum HeaderCellAction: CaseAccessible {
  case myMenu(HomeHeaderItem)
  case map(HomeHeaderItem)
  case search(HomeHeaderItem)
  case call(DetailCampsiteHeaderItem)
  case reserve(DetailCampsiteHeaderItem)
  case visit(DetailCampsiteHeaderItem)
  case like(DetailCampsiteHeaderItem)
  case pager(DetailCampsiteHeaderItem, String)
}
