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
}

extension DetailLocationWeatherCell: ViewRepresentable {
  func setupView() {
    [iconImageView, dateLabel, maxLabel, minLabel].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    dateLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(8.0)
    }
    
    iconImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(dateLabel.snp.bottom).offset(8.0)
      $0.width.equalTo(32.0)
      $0.height.equalTo(32.0)
    }
    
    maxLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(iconImageView.snp.bottom).offset(4.0)
    }
    
    minLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(maxLabel.snp.bottom).offset(4.0)
      $0.bottom.equalToSuperview().offset(-8.0)
    }
  }
  
  func setupData(weatherInfo: WeatherInfo) {
    dateLabel.text = weatherInfo.date?.toString(format: "MM.dd")
    guard let iconString = weatherInfo.weatherIcon else { return }
    let urlString = "https://openweathermap.org/img/wn/\(iconString)@2x.png"
    let url = URL(string: urlString)
    let processor = DownsamplingImageProcessor(size: CGSize(width: 64, height: 64))
    iconImageView.kf.indicatorType = .activity
    iconImageView.kf.setImage(
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
    
    let digit: Double = pow(10, 1)
    maxLabel.text = "M: \(round(weatherInfo.maxTemp! * digit) / digit)"
    minLabel.text = "m: \(round(weatherInfo.minTemp! * digit) / digit)"
  }
}
