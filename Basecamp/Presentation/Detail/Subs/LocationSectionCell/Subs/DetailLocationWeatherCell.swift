//
//  DetailLocationWeatherCell.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2023/01/06.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailLocationWeatherCell: UICollectionViewCell {
  static let identifier = "DetailLocationWeatherCell"
  
  lazy var iconImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      return imageView
  }()
  
  lazy var dateLabel = DefaultLabel(font: .body3R14)
  lazy var maxLabel = DefaultLabel(font: .body4R12, textColor: .systemRed)
  lazy var minLabel = DefaultLabel(font: .body4R12, textColor: .systemBlue)
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    iconImageView.kf.cancelDownloadTask()
    iconImageView.image = nil
  }
}

extension DetailLocationWeatherCell: ViewRepresentable {
  func setupView() {
    [iconImageView, dateLabel, maxLabel, minLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    iconImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.equalTo(45.0)
      $0.height.equalTo(45.0)
    }
    
    maxLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(iconImageView.snp.bottom)
    }
    
    minLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(maxLabel.snp.bottom)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(minLabel.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func setupData(weatherInfo: WeatherInfo) {
    dateLabel.text = weatherInfo.date?.toString(format: "M.d(E)")
    guard let iconString = weatherInfo.weatherIcon else { return }
    iconImageView.image = UIImage(named: iconString)
    
    let digit: Double = pow(10, 1)
    maxLabel.text = "M: \(round(weatherInfo.maxTemp! * digit) / digit)"
    minLabel.text = "m: \(round(weatherInfo.minTemp! * digit) / digit)"
  }
}
