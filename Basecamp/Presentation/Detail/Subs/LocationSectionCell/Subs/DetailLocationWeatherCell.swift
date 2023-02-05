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
  
  lazy var dateLabel = DefaultLabel(font: .captionR10)
  lazy var maxLabel = DefaultLabel(font: .captionR10, textColor: .systemRed)
  lazy var minLabel = DefaultLabel(font: .captionR10, textColor: .systemBlue)
  
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
      $0.top.equalTo(dateLabel.snp.bottom)
      $0.width.equalTo(36.0)
      $0.height.equalTo(36.0)
    }
    
    maxLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(iconImageView.snp.bottom)
    }
    
    minLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(maxLabel.snp.bottom)
      $0.bottom.equalToSuperview().offset(-4.0)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
  
  func setupData(weatherInfo: WeatherInfo) {
    dateLabel.text = weatherInfo.date?.toString(format: "M.d(E)")
    guard let iconString = weatherInfo.weatherIcon else { return }
    iconImageView.image = UIImage(named: iconString)
    
    let digit: Double = pow(10, 1)
    maxLabel.text = "M: \(round(weatherInfo.maxTemp! * digit) / digit) ℃"
    minLabel.text = "m: \(round(weatherInfo.minTemp! * digit) / digit) ℃"
  }
}
